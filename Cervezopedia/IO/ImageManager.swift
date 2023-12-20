//
//  ImageHandler.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 16/12/23.
//

import Foundation
import UIKit

/// Gestor de E/S para las imágenes. Permite cargar, eliminar o incluso comprobar si existen archivos de imagen en una carpeta.
struct ImageManager { // TODO: - Añadir `ErrorType` *enum* para gestionar mejor los errores y (cambiar el nombre quizas?)
    // MARK: - Properties
    /// La carpeta objetivo.
    private let imagePath: URL
    
    // MARK: - Initializers
    init(imagePath: URL) {
        self.imagePath = imagePath
    }
    
    // MARK: - Methods
    private func getPathToFile(withName name: String) -> URL {
        return imagePath.appendingPathComponent(name)
    }
    
    /// Guarda la imagen en la carpeta objetivo.
    ///
    ///  - Parameters:
    ///     - image: Imagen a guardar.
    ///     - name: Nombre con el que se guarda la imagen.
    ///
    ///  - Returns: Devuelve `true` si la operación ha sido exitosa, sino devuelve `false`.
    func save(image: UIImage, withName name: String) -> Bool {
        guard let data = image.pngData() else { return false }
        
        do {
            try data.write(to: getPathToFile(withName: name))
            return true
        } catch {
            return false
        }
    }

    /// Elimina la imagen en la carpeta objetivo.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la imagen a eliminar.
    ///
    ///  - Returns: Devuelve `true` si la operación ha sido exitosa, sino devuelve `false`.
    func removeImage(withName name: String) -> Bool {
        do {
            try FileManager.default.removeItem(at: getPathToFile(withName: name))
            return true
        } catch {
            return false
        }
    }
    
    /// Elimina todas las imágenes de la carpeta objetivo.
    func clearImages() {
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at: imagePath, includingPropertiesForKeys: nil, options: [])
            for fileUrl in fileUrls {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            
        }
    }
    
    /// Obtiene todas las imágenes y sus nombres de la carpeta objetivo. Es la función que hace de puente con la inicialización del caché de `ImageCache`.
    ///
    ///  - Returns: Si la operación ha sido exitosa, devuelve un diccionario con los pares clave-valor ya descritos, sino devuelve un diccionario vacío.
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
    
    /// Comprueba si existe una imagen en la carpeta objetivo.
    ///
    ///  - Parameters:
    ///     - withName: Nombre de la imagen a buscar.
    ///
    ///  - Returns: Devuelve `true` si la imagen se ha encontrado, sino devuelve `false`
    func existsImage(withName name: String) -> Bool {
        let fileUrl = getPathToFile(withName: name)
        return FileManager.default.fileExists(atPath: fileUrl.path)
    }
}
