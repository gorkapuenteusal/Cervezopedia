//
//  BeerImageManager.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

final class BeerImageManager: ObservableObject { // TODO: - Crear vista `BeerImageManagerView`
    static let shared = BeerImageManager()
    
    private let beerImagesDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeerImages")
    private let handler: ImageManager
    
    @Published var beerImageCache: ImageCache
    
    private init() {
        handler = ImageManager(imagePath: beerImagesDirectory)
        beerImageCache = ImageCache(namesAndImages: handler.getNamesAndImages())
        initBeerImagesFolder()
    }
    
    private func initBeerImagesFolder() {
        try! FileManager.default.createDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeerImages"), withIntermediateDirectories: true)
    }
    
    func saveBeerImage(whitName name: String, andBeerImage beerImage: UIImage?) {
        if let beerImage = beerImage {
            if handler.save(image: beerImage, withName: name) {
                _ = beerImageCache.addEntry(withName: name, andImage: beerImage)
            }
        } else {
            _ = beerImageCache.addEntry(withName: name, andImage: beerImage)
        }
    }
    
    func removeBeerImage(withName name: String) {
        if beerImageCache.removeEntry(withName: name) {
            _ = handler.removeImage(withName: name)
        }
    }
    
    func clearBeerImages() {
        handler.clearImages()
        beerImageCache.clear()
    }
    
    func existsBeerImage(withName name: String) -> Bool {
        return beerImageCache.existsImage(withName: name)
    }
}
