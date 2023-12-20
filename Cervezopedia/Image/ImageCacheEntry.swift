//
//  ImageNameWrapper.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

struct ImageCacheEntry: Hashable {
    var name: String
    let image: UIImage
    
    private static let defaultName = "image"
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
