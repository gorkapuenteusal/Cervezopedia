//
//  Manufacturer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

struct ManufacturerModel: Codable {
    var location: String
    var logoPath: String
    var name: String
    var beers: [BeerModel]
}
