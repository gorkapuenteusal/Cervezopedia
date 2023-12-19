//
//  Manufacturer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Modelo del manufacturador de cervezass
struct ManufacturerModel: Codable, Equatable, Identifiable, Hashable { // TODO: - Añadir tests para fotos que existan y que no existan
    static let defaultManufacturer = ManufacturerModel(name: "", location: Locale.current.region!.identifier, withLogoName: "")!
    var name: String
    var beers: [BeerModel]
    
    /// Localización del manufacturador y sus cervezas. Se gestiona mediante el subsistema `Locale` de *Swift*. Si se modifica a un valor no valido permanecerá el antiguo
    var location: String {
        didSet {
            if !Locale.Region.isoRegions.contains(where: {$0.identifier == location}) {
                location = oldValue
            }
        }
    }
    
    /// Ruta del logotipo del manufacturador. Se gestiona mediante el `LogoManager`. Si se modifica a un valor no valido permanecerá el antiguo
    var logoName: String {
        didSet {
            guard !logoName.isEmpty && LogoManager.shared.existsLogo(withName: logoName) else {
                logoName = oldValue
                return
            }
        }
    }
    
    /// Cadena de texto identificativa del manufacturador. No pueden existir dos iguales.
    var id: String
    
    
    /// Inicializador opcional. Si el `location` que se pasa como parámetro no es un identificador de ningún `Locale` devuelve `nil`. Si el `logoPath` que se pasa como parámetro no es `nil` y encima no existe en el `LogoManager` devuelve `nil`.
    init?(name: String, location: String, withLogoName logoName: String) {
        guard Locale.Region.isoRegions.contains(where: { $0.identifier == location}) else {
            return nil
        }
        
        guard logoName.isEmpty || LogoManager.shared.existsLogo(withName: logoName) else {
            return nil
        }
        
        self.name = name
        self.location = location
        self.logoName = LogoManager.shared.existsLogo(withName: logoName) ? logoName : ""
        self.beers = []
        self.id = "\(location)/\(name)"
    }

    /// Inicializador opcional. Permite elegir sus cervezas desde que es inicializado
    init?(name: String, location: String, withLogoName logoName: String, beers: [BeerModel]) {
        guard Locale.Region.isoRegions.contains(where: { $0.identifier == location}) else {
            return nil
        }
        
        guard logoName.isEmpty || LogoManager.shared.existsLogo(withName: logoName) else {
            return nil
        }
        
        self.name = name
        self.location = location
        self.logoName = logoName
        self.beers = beers
        self.id = "\(location)/\(name)"
    }
    
    /// Devuelve `true`si el productor es **nacional** y `false` si es **importado**  respecto a la nacionalidad del usuario.
    public func isNational() -> Bool {
        if let userRegion = Locale.current.language.region {
            return userRegion.identifier == location;
        } else {
            return false
        }
    }
    
    static func == (lhs: ManufacturerModel, rhs: ManufacturerModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
