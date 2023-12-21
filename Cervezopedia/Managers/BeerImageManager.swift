//
//  BeerImageManager.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

/// Gestor de imágenes de cerveza, el encargado de administrar todas las imágenes de cerveza de cada una de ellas. Contiene una instancia de gestor de imágenes para proporcionarle E/S y otra de caché para no tener que interferir constantemente la carga y el guardado de archivos.
struct BeerImageManager { // TODO: - Se podría abstraer con `LogoManager`?
    // MARK: - Type properties
    private static let defaultBeerImage: UIImage = UIImage(systemName: "drop.triangle")! // TODO: - Debe ser una imagen de una botella.
    
    /// Instancia compartida de `BeerImagemanager`, utilizando el patrón *Singleton*
    static let shared = BeerImageManager()
    
    // MARK: - Properties
    private let beerImagesDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeerImages")
    private let beerImageManager: ImageManager
    
    private(set) var beerImageCache: ImageCache
    
    // MARK: - Initializers
    private init() {
        beerImageManager = ImageManager(imagePath: beerImagesDirectory)
        beerImageCache = ImageCache(namesAndImages: beerImageManager.getNamesAndImages())
        initBeerImagesFolder()
    }
    
    // MARK: - Methods
    private func initBeerImagesFolder() {
        do {
            try FileManager.default.createDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeerImages"), withIntermediateDirectories: true)
            print("Succesfully initialized \"BeerImages\" folder")
        } catch {
            print("Error while initializing \"BeerImages\" folder: FATAL ERROR!")
        }
    }
    
    /// Guarda la imagen de cerveza si es posible en el sistema de ficheros y en el caché al mismo tiempo.
    ///
    /// - Parameters:
    ///    - beerImage: Imagen de cerveza a guardar.
    ///    - withName: Nombre con el que se guarda la imagen de cerveza.
    func save(beerImage: UIImage, withName name: String) {
        if beerImageCache.addEntry(withName: name, andImage: beerImage) { // TODO: - Cambiar lógica de "logging" de "if" a "guard"
            if beerImageManager.save(image: beerImage, withName: name) {
                print("Succesfully saved beer image \"\(name)\"")
                return
            }
            if beerImageCache.removeEntry(withName: name) == nil {
                print("Error while removing wrong beer image \"\(name)\": FATAL ERROR!")
                return
            }
            print("Error while saving beer image \"\(name)\": error in beerImageManager")
            return
        }
        print("Error while saving beer image \"\(name)\": error in beerImageCache")
    }
    
    /// Elimina la imagen de cerveza si es posible en el sistema de ficheros y en el caché al mismo tiempo.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la imagen de cerveza a eliminar.
    func removeBeerImage(withName name: String) { // TODO: - Cambiar lógica de "logging" de "if" a "guard"
        if let removedCacheBeerImage = beerImageCache.removeEntry(withName: name) {
            if beerImageManager.removeImage(withName: name) {
                print("Succesfully removed beer image \"\(name)\"")
                return
            }
            if !beerImageCache.addEntry(withName: name, andImage: removedCacheBeerImage) {
                print("Error while re-adding wrong beer image \"\(name)\": FATAL ERROR!")
                return
            }
            print("Error while removing beer image \"\(name)\": beer image not in folder")
            return
        }
        print("Error while removing beer image \"\(name)\": beer image not cached")
    }
    
    /// Elimina todas las imágenes de cerveza del caché y del sistema de ficheros.
    func clearBeerImages() {
        beerImageManager.clearImages()
        beerImageCache.clear()
    }
    
    /// Comprueba si existe una imagen de cerveza con el mismo nombre en el caché.
    ///
    /// - Returns: Devuelve `true` si encuentra en la imagen de cerveza, sino devuelve `false`
    func existsBeerImage(withName name: String) -> Bool {
        return beerImageCache.existsImage(withName: name)
    }
    
    /// Obtiene una imagen de cerveza con el mismo nombre.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la imagen de cerveza a obtener.
    ///
    ///  - Returns: Devuelve la imagen de cerveza con el mismo nombre y si no la encuentra, devuelve la imagen de cerveza por defecto.
    func getBeerImage(withName name: String) -> UIImage {
        guard let beerImage = beerImageCache.getImage(withName: name) else {
            print("Returning default beer image")
            return Self.defaultBeerImage
        }
        
        print("Returning \"\(name)\" beer image")
        return beerImage
    }
}
