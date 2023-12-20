//
//  ImageCache.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

final class ImageCache: ObservableObject {
    @Published var cache: [ImageCacheEntry] = []
    
    init(namesAndImages: [String: UIImage] = [:]) {
        namesAndImages.forEach { key, value in
            _ = addEntry(withName: key, andImage: value)
        }
    }
    
    func addEntry(withName name: String, andImage image: UIImage) -> Bool {
        self.cache.append(ImageCacheEntry(name: name, image: image))
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
    
    func getImage(withName name: String) -> UIImage? {
        if let entry = cache.first(where: { entry in
            entry.name == name
        }) {
            return entry.image
        }
        return nil
    }
    
    func getAllEntries() -> [ImageCacheEntry] {
        return cache
    }
}
