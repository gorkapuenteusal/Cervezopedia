//
//  ImageNameWrapper.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

/// Entrada del caché de imágenes. Es una clase inmutable ya que las imágenes o se añaden o se eliminan, no se pueden editar.
struct ImageCacheEntry: Hashable {
    // MARK: - Properties
    /// La clave o *key* del caché. Es el nombre con el que se guarda la imagen en la carpeta de la aplicación correspondiente.
    let name: String
    /// El valor o *value* del caché.
    let image: UIImage
    
    // MARK: - Initializers
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    // MARK: - Hashable requirements
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
