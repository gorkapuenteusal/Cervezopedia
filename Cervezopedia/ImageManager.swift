//
//  ImageHandler.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 16/12/23.
//

import Foundation
import UIKit

struct ImageManager {
    let imagePath: URL
    
    init(imagePath: URL) {
        self.imagePath = imagePath
    }
    
    func save(image: UIImage, withName name: String) -> Bool {
        if let data = image.pngData() {
            do {
                try data.write(to: getPathToFile(withName: name))
                return true
            } catch {
                return false
            }
        }
        return false
    }

    
    func removeImage(withName name: String) -> Bool {
        do {
            try FileManager.default.removeItem(at: getPathToFile(withName: name))
            return true
        } catch {
            return false
        }
    }
    
    func clearImages() {
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at: imagePath, includingPropertiesForKeys: nil, options: [])
            for fileUrl in fileUrls {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            
        }
    }
    
    func getNamesAndImages() -> [String:UIImage] {
        var namesAndImages: [String:UIImage] = [:]
        do {
            let imageUrls = try FileManager.default.contentsOfDirectory(at: imagePath, includingPropertiesForKeys: nil, options: [])
            for imageUrl in imageUrls {
                if let image = UIImage(contentsOfFile: imageUrl.path()) {
                    let name = imageUrl.lastPathComponent
                    let nameWithoutExtension = (name as NSString).deletingPathExtension
                    namesAndImages[nameWithoutExtension] = image
                }
            }
            return namesAndImages
        } catch {
            return [:]
        }
    }
    
    private func getPathToFile(withName name: String) -> URL {
        return imagePath.appendingPathComponent(name)
    }
}
