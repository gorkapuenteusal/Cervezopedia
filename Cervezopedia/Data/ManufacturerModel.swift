//
//  Manufacturer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Modelo del manufacturador de cervezass
final class ManufacturerModel: Codable, Equatable, Hashable, Identifiable, ObservableObject  { // TODO: - Añadir tests para fotos que existan y que no existan
    // MARK: - Properties
    @Published var name: String
    @Published var beers: [BeerModel]
    
    /// Localización del manufacturador y sus cervezas. Se gestiona mediante el subsistema `Locale` de *Swift*. Si se modifica a un valor no valido permanecerá el antiguo
    @Published var location: String { // TODO: - extraer lógica a gestor de región
        didSet {
            guard Locale.Region.isoRegions.contains(where: { region in
                region.identifier == location
            }) else {
                location = oldValue
                return
            }
        }
    }
    
    /// Ruta del logotipo del manufacturador. Se gestiona mediante el `LogoManager`. Si se modifica a un valor no valido permanecerá el antiguo
    @Published var logoName: String {
        didSet {
            guard logoName.isEmpty || LogoManager.shared.existsLogo(withName: logoName) else {
                logoName = oldValue
                return
            }
        }
    }
    
    /// Cadena de texto identificativa del manufacturador. No pueden existir dos iguales.
    @Published var id: String
    
    // MARK: - Initializers
    /// Inicializador opcional. Si el `location` que se pasa como parámetro no es un identificador de ningún `Locale` devuelve `nil`. Si el `logoPath` que se pasa como parámetro no es `nil` y encima no existe en el `LogoManager` devuelve `nil`.
    init?(name: String, location: String, logoName: String, beers: [BeerModel] = []) {
        guard !name.isEmpty else {
            print("Failed to initialize manufacturer: the name cannot be empty")
            return nil
        }
        guard Locale.Region.isoRegions.contains(where: { region in // TODO: - No debería ser necesario
            region.identifier == location
        }) else {
            print("Failed to initialize manufacturer: the location is not valid ")
            return nil
        }
        guard logoName.isEmpty || LogoManager.shared.existsLogo(withName: logoName) else {
            print("Failed to initialize manufacturer: the logo does not exist ")
            return nil
        }
            
        self.name = name
        self.location = location
        self.logoName = LogoManager.shared.existsLogo(withName: logoName) ? logoName : "" // TODO: - No debería ser necesario (Comprobar si con la serialización lo es)
        self.beers = beers
        self.id = "\(location)/\(name)"
    }
    
    // MARK: - Methods
    /// Devuelve `true`si el productor es **nacional** y `false` si es **importado**  respecto a la nacionalidad del usuario.
    public func isNational() -> Bool {
        if let userRegion = Locale.current.language.region {
            return userRegion.identifier == location;
        } else {
            return false
        }
    }
    
    // MARK: - Codable requirements
    enum CodingKeys: CodingKey {
        case name, beers, location, logoName, id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(beers, forKey: .beers)
        try container.encode(location, forKey: .location)
        try container.encode(logoName, forKey: .logoName)
        try container.encode(id, forKey: .id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        beers = try container.decode([BeerModel].self, forKey: .beers)
        location = try container.decode(String.self, forKey: .location)
        logoName = try container.decode(String.self, forKey: .logoName)
        id = try container.decode(String.self, forKey: .id)
    }
    
    // MARK: - Equatable requirements
    static func == (lhs: ManufacturerModel, rhs: ManufacturerModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Hashable requirements
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
