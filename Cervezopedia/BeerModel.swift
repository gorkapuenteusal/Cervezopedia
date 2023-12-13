//
//  Beer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Modelo de la cerveza.
struct BeerModel: Codable {
    var type: BeerType
    var name: String
    /// Ruta de acceso a la imagen identificativa de la cerveza. Se gestiona mediante el `ImageManager`
    var imagePath: String
    var alcoholContent: Double
    var caloricIntake: Int
    
    /// Cadena de texto identificativa de cada cerveza. No pueden existir dos iguales en el mismo manufacturador.
    lazy var id = name;
}
