//
//  ImageNameWrapper.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

struct ImageCacheEntry {
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
