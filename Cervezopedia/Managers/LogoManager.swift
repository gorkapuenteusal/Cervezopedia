//
//  LogoManager.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

final class LogoManager {
    private static let defaultLogo: UIImage = UIImage(systemName: "person.crop.circle")!
    static let shared = LogoManager()
    
    private let logosDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logos")
    private let logoManager: ImageManager
    
    private(set) var logoCache: ImageCache
    
    private init() {
        logoManager = ImageManager(imagePath: logosDirectory)
        logoCache = ImageCache(namesAndImages: logoManager.getNamesAndImages())
        initLogosFolder()
    }
    
    private func initLogosFolder() {
        do {
            try FileManager.default.createDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logos"), withIntermediateDirectories: true)
            print("Succesfully initialized \"Logos\" folder")
        } catch {
            print("Error while initializing \"Logos\" folder: FATAL ERROR!")
        }
    }
    
    func saveLogo(whitName name: String, andLogo logo: UIImage) {
        if logoManager.save(image: logo, withName: name) {
            if logoCache.addEntry(withName: name, andImage: logo) {
                print("Succesfully saved image \"\(name)\"")
                return
            }
            print("Error while saving image \"\(name)\": error in logoCache")
            return
        }
        print("Error while saving image \"\(name)\": error in logoManager")
    }
    
    func removeLogo(withName name: String) {
        if logoCache.removeEntry(withName: name) {
            if logoManager.removeImage(withName: name) {
                print("Succesfully removed image \"\(name)\"")
                return
            }
            print("Error while removing image \"\(name)\": error in logoCache")
            return
        }
        print("Error while removing image \"\(name)\": error in logoManager")
    }
    
    func clearLogos() {
        logoManager.clearImages()
        logoCache.clear()
        print("Cleared logos")
    }
    
    func existsLogo(withName name: String) -> Bool {
        return logoCache.existsImage(withName: name)
    }
    
    func getLogo(withName name: String?) -> UIImage {
        if let name = name {
            if logoCache.existsImage(withName: name) {
                print("Returning \"\(name)\" logo")
                return logoCache.getImage(withName: name)!
            }
        }
        print("Returning default logo")
        return Self.defaultLogo
    }
}
