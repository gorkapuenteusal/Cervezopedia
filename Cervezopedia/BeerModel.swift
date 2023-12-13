//
//  Beer.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

struct BeerModel: Codable {
    var type: BeerType
    var name: String
    var imagePath: String
    var alcoholContent: Double
    var caloricIntake: Int
}
