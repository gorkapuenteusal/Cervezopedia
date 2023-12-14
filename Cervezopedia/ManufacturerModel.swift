//
//  Manufacturer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Modelo del manufacturador de cervezas
struct ManufacturerModel: Codable {
    /// Localización del manufacturador y sus cervezas. Se gestiona mediante el subsistema `Locale` de *Swift*.
    var location: String
    /// Ruta del logotipo del manufacturador. Se gestiona mediante el `ImageManager`
    var logoPath: String
    var name: String
    var beers: [BeerModel]
    
    /// Cadena de texto identificativa del manufacturador. No pueden existir dos iguales.
    lazy var id = "\(location)/\(name)"
    
    /// Devuelve si el productor es local o extranjero respecto a la nacionalidad del usuario.
    public func isLocal() -> Bool {
        return Locale.current.identifier == location;
    }
}
