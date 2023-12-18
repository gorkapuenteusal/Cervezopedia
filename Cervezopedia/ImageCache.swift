//
//  ImageCache.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

final class ImageCache: ObservableObject { // TODO: - Se debería eliminar la opción de añadir un nombre sin imagen. Ésto se había hecho para gestionar los casos en los que al no haber imagen, es decir el valor fuese `nil`, se le pusiese una imagen por defecto. Pero eso mismo lleva a conflictos con el `ImageManager` al que se asocia esta clase en los gestores de logos y de imágenes de cerveza.
    @Published var cache: [ImageCacheEntry] = []
    
    init(namesAndImages: [String: UIImage] = [:]) {
        namesAndImages.forEach { key, value in
            _ = addEntry(withName: key, andImage: value)
        }
    }
    
    func addEntry(withName name: String?, andImage image: UIImage?) -> Bool {
        guard let entry = ImageCacheEntry(name: name, image: image) else {
            return false
        }
        self.cache.append(entry)
        return true
    }
    
    func removeEntry(withName name: String) -> Bool {
        guard let idx = cache.firstIndex(where: { $0.name == name }) else {
            return false
        }
        cache.remove(at: idx)
        return true
    }
    
    func clear() {
        cache = []
    }
    
    func existsImage(withName name: String) -> Bool {
        return cache.contains { entry in
            entry.name == name
        }
    }
}
