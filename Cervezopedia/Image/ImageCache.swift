//
//  ImageCache.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

/// Caché de imágenes. Permite una carga más rápida de imágenes y una más sencilla gestión de las mismas haciendo de intermediario entre la vista y el gestor de ficheros `ImageManager`.
final class ImageCache: ObservableObject { // TODO: - Hacer que herede de [ImageCacheEntry] para mayor limpieza de código
    // MARK: - Properties
    /// Contiene la lista de imágenes en el caché en forma de entrada de caché, publicada para notificar cambios a las vistas.
    @Published var entries: [ImageCacheEntry] = []
    
    // MARK: - Initializers
    /// Inicializa el caché usando un diccionario que contiene pares clave-valor que corresponde a cada una de las entradas.
    ///
    ///  - Parameters:
    ///     - namesAndImages: El diccionario en cuestión. Su valor por defecto es un diccionario vació.
    init(namesAndImages: [String: UIImage] = [:]) {
        namesAndImages.forEach { key, value in // TODO: - ¿Qué pasa si dos entradas tienen el mismo nombre?
            _ = addEntry(withName: key, andImage: value)
        }
    }
    
    // MARK: - Methods
    /// Añade una nueva entrada si no existe ya una con el mismo nombre.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la nueva entrada.
    ///     - image: Imagen de la nueva entrada.
    ///
    ///  - Returns: Devuelve `false` si no se añade la nueva entrada con exito, sino devuelve `true`.
    func addEntry(withName name: String, andImage image: UIImage) -> Bool {
        guard !entries.contains(where: { entry in
            entry.name == name
        }) else { return false }
        
        self.entries.append(ImageCacheEntry(name: name, image: image))
        return true
    }
    
    /// Elimina una entrada solo si ya existe, es decir si existe una con el mismo nombre.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la entrada a eliminar.
    ///
    ///  - Returns: Devuelve `nil` si no se elimina la entrada con exito, sino devuelve la imagen de la entrada eliminada.
    func removeEntry(withName name: String) -> UIImage? {
        guard let idx = entries.firstIndex(where: { entry in
            entry.name == name
        }) else { return nil }
        
        return entries.remove(at: idx).image
    }
    
    /// Vacía por completo el caché.
    func clear() {
        entries = []
    }
    
    /// Comprueba si existe una imagen en el caché.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la imagen a buscar.
    ///
    ///  - Returns: Devuelve `true` si la imagen se ha encontrado, sino devuelve `false`
    func existsImage(withName name: String) -> Bool {
        return entries.contains { entry in
            entry.name == name
        }
    }
    
    /// Obtiene la imagen con el mismo nombre.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la imagen a obtener.
    ///
    ///  - Returns: Devuelve la imagen con el mismo nombre y si no la encuentra, devuelve `nil`.
    func getImage(withName name: String) -> UIImage? {
        guard existsImage(withName: name) else { return nil }
        
        return entries.first { entry in
            entry.name == name
        }!.image
    }
}
