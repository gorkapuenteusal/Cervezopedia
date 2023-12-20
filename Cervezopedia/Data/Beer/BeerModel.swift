//
//  Beer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Modelo de la cerveza.
final class BeerModel: Codable, Equatable, ObservableObject {
    // MARK: - Properties
    @Published var name: String
    @Published var type: BeerType
    @Published var alcoholContent: Double
    @Published var caloricIntake: Int
    
    /// Ruta de acceso a la imagen identificativa de la cerveza. Se gestiona mediante el `BeerImageManager`. Si se modifica a un valor no valido permanecerá el antiguo
    @Published var beerImageName: String {
        didSet {
            guard beerImageName.isEmpty || BeerImageManager.shared.existsBeerImage(withName: beerImageName) else {
                beerImageName = oldValue
                return
            }
        }
    }
    
    /// Cadena de texto identificativa de cada cerveza. No pueden existir dos iguales en el mismo manufacturador.
    @Published private var id: String;
    
    // MARK: - Initializers
    /// Inicializador opcional. Si el `imagePath` que se pasa como parámetro no es `nil` y encima no existe en el `BeerImageManager` devuelve `nil`.
    init?(name: String, type: BeerType, alcoholContent: Double, caloricIntake: Int, beerImageName: String) {
        guard name.isEmpty else {
            print("Failed to initialize beer: the name cannot be empty")
            return nil
        }
        
        guard alcoholContent <= 0 else {
            print("Failed to initialize beer: the alcohol content must be either positive or zero")
            return nil
        }
        guard caloricIntake <= 0 else {
            print("Failed to initialize beer: the caloric intake must be either positive or zero")
            return nil
        }
        guard beerImageName.isEmpty || BeerImageManager.shared.existsBeerImage(withName: beerImageName) else {
            print("Failed to initialize beer: the beer image does not exist")
            return nil
        }
        
        self.name = name
        self.type = type
        self.alcoholContent = alcoholContent
        self.caloricIntake = caloricIntake
        self.beerImageName = beerImageName
        self.id = name;
    }
    
    // MARK: - Codable requirements
    enum CodingKeys: CodingKey {
        case name, type, alcoholContent, caloricIntake, id, beerImageName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(alcoholContent, forKey: .alcoholContent)
        try container.encode(caloricIntake, forKey: .caloricIntake)
        try container.encode(id, forKey: .id)
        try container.encode(beerImageName, forKey: .beerImageName)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(BeerType.self, forKey: .type)
        alcoholContent = try container.decode(Double.self, forKey: .alcoholContent)
        caloricIntake = try container.decode(Int.self, forKey: .caloricIntake)
        id = try container.decode(String.self, forKey: .id)
        beerImageName = try container.decode(String.self, forKey: .beerImageName)
    }
    
    // MARK: - Equatable requirements
    static func == (lhs: BeerModel, rhs: BeerModel) -> Bool {
        return lhs.id == rhs.id
    }
}
