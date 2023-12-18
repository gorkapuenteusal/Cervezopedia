//
//  LogoManager.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 17/12/23.
//

import Foundation
import UIKit

final class LogoManager: ObservableObject { // TODO: - Crear vista `LogoManagerView`
    static let shared = LogoManager()
    
    private let logosDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logos")
    private let handler: ImageManager
    
    @Published var logoCache: ImageCache
    
    private init() {
        handler = ImageManager(imagePath: logosDirectory)
        logoCache = ImageCache(namesAndImages: handler.getNamesAndImages())
        initLogosFolder()
    }
    
    private func initLogosFolder() {
        try! FileManager.default.createDirectory(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logos"), withIntermediateDirectories: true)
    }
    
    func saveLogo(whitName name: String, andLogo logo: UIImage?) {
        if let logo = logo {
            if handler.save(image: logo, withName: name) {
                _ = logoCache.addEntry(withName: name, andImage: logo)
            }
        } else { // TODO: - Eliminar esta opción
            _ = logoCache.addEntry(withName: name, andImage: logo)
        }
    }
    
    func removeLogo(withName name: String) {
        if logoCache.removeEntry(withName: name) {
            _ = handler.removeImage(withName: name)
        }
    }
    
    func clearLogos() {
        handler.clearImages()
        logoCache.clear()
    }
    
    func existsLogo(withName name: String) -> Bool {
        return logoCache.existsImage(withName: name)
    }
}
