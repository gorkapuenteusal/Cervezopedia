//
//  Beer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Modelo de la cerveza.
struct BeerModel: Codable, Equatable {
    var name: String
    var type: BeerType
    var alcoholContent: Double
    var caloricIntake: Int
    
    /// Cadena de texto identificativa de cada cerveza. No pueden existir dos iguales en el mismo manufacturador.
    var id: String;
    
    /// Ruta de acceso a la imagen identificativa de la cerveza. Se gestiona mediante el `BeerImageManager`. Si se modifica a un valor no valido permanecerá el antiguo
    var beerImageName: String? {
        didSet {
            if beerImageName != nil || !BeerImageManager.shared.existsBeerImage(withName: beerImageName!) {
                beerImageName = oldValue
            }
        }
    }
    
    /// Inicializador opcional. Si el `imagePath` que se pasa como parámetro no es `nil` y encima no existe en el `BeerImageManager` devuelve `nil`.
    init?(name: String, type: BeerType, alcoholContent: Double, caloricIntake: Int, withImageName imageName: String?) {
        guard imageName == nil || BeerImageManager.shared.existsBeerImage(withName: imageName!) else {
            return nil
        }
        
        self.name = name
        self.type = type
        self.alcoholContent = alcoholContent
        self.caloricIntake = caloricIntake
        self.beerImageName = imageName
        self.id = name;
    }
    
    static func == (lhs: BeerModel, rhs: BeerModel) -> Bool {
        return lhs.id == rhs.id
    }
}
