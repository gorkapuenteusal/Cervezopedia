//
//  LogoManager.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

/// Gestor de logos, el encargado de administrar todos los logos de los fabricantes. Contiene una instancia de gestor de imágenes para proporcionarle E/S y otra de caché para no tener que interferir constantemente con la carga y el guardado de archivos.
struct LogoManager { // TODO: - Se podría abstraer con `BeerImageManager`?
    // MARK: - Type properties
    private static let defaultLogo: UIImage = UIImage(systemName: "person.crop.circle")! // TODO: - Debe ser una imagen de una chapa.
    
    /// Instancia compartida de `LogoManager`, utilizando el patrón *Singleton*.
    static let shared = LogoManager()
    
    // MARK: - Properties
    private let logosDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logos")
    private let logoManager: ImageManager
    
    private(set) var logoCache: ImageCache
    
    // MARK: - Initializers
    private init() {
        logoManager = ImageManager(imagePath: logosDirectory)
        logoCache = ImageCache(namesAndImages: logoManager.getNamesAndImages())
        initLogosFolder()
    }
    
    // MARK: - Methods
    private func initLogosFolder() {
        do {
            try FileManager.default.createDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logos"), withIntermediateDirectories: true)
            print("Succesfully initialized \"Logos\" folder")
        } catch {
            print("Error while initializing \"Logos\" folder: FATAL ERROR!")
        }
    }
    
    /// Guarda el logo si es posible en el sistema de ficheros y en el caché al mismo tiempo.
    ///
    /// - Parameters:
    ///    - logo: Logo a guardar.
    ///    - withName: Nombre con el que se guarda el logo.
    func save(logo: UIImage, withName name: String) {
        if logoCache.addEntry(withName: name, andImage: logo) { // TODO: - Cambiar lógica de "logging" de "if" a "guard"
            if logoManager.save(image: logo, withName: name) {
                print("Succesfully saved logo \"\(name)\"")
                return
            }
            if logoCache.removeEntry(withName: name) == nil {
                print("Error while removing wrong logo \"\(name)\": FATAL ERROR!")
                return
            }
            print("Error while saving logo \"\(name)\": error in logoManager")
            return
        }
        print("Error while saving logo \"\(name)\": error in logoCache")
    }
    
    /// Elimina el logo si es posible en el sistema de ficheros y en el caché al mismo tiempo.
    ///
    ///  - Parameters:
    ///     - withName: Nombre del logo a eliminar.
    func removeLogo(withName name: String) { // TODO: - Cambiar lógica de "logging" de "if" a "guard"
        if let removedCacheLogo = logoCache.removeEntry(withName: name) {
            if logoManager.removeImage(withName: name) {
                print("Succesfully removed logo \"\(name)\"")
                return
            }
            if !logoCache.addEntry(withName: name, andImage: removedCacheLogo) {
                print("Error while re-adding wrong logo \"\(name)\": FATAL ERROR!")
                return
            }
            print("Error while removing logo \"\(name)\": logo not in folder")
            return
        }
        print("Error while removing logo \"\(name)\": logo not cached")
    }
    
    /// Elimina todos los logos del caché y del sistema de ficheros.
    func clearLogos() {
        logoManager.clearImages()
        logoCache.clear()
        print("Cleared logos")
    }
    
    /// Comprueba si existe un logo con el mismo nombre en el caché.
    ///
    /// - Returns: Devuelve `true` si encuentra en logo, sino devuelve `false`
    func existsLogo(withName name: String) -> Bool {
        return logoCache.existsImage(withName: name)
    }
    
    /// Obtiene un logo con el mismo nombre.
    ///
    ///  - Parameters:
    ///     - withName: Nombre del logo a obtener.
    ///
    ///  - Returns: Devuelve el logo con el mismo nombre y si no la encuentra, devuelve el logo por defecto.
    func getLogo(withName name: String) -> UIImage {
        guard let logo = logoCache.getImage(withName: name) else {
            print("Returning default logo")
            return Self.defaultLogo
        }
        
        print("Returning \"\(name)\" logo")
        return logo
    }
}
