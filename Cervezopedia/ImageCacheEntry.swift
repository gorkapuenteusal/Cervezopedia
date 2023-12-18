//
//  ImageNameWrapper.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

struct ImageCacheEntry { // TODO: - en vez de usar esto usar el `accesibilityIdentifier` como nombre de la imagen
    var name: String
    let image: UIImage?
    
    private static let defaultName = "image"
    
    init?(name: String? = nil, image: UIImage?) {
        guard let name = name ?? image?.description else {
            return nil
        }
        self.name = name
        self.image = image
    }
}
