//
//  BeerType.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 13/12/23.
//

import Foundation

/// Tipos de cervezas. Constantes y no hay intención de que sea expansible
enum BeerType: String, CaseIterable, Codable {
    case sinFiltro
    case bock
    case dunkel
    case helles
    case kellerbier
    case export
    case pilsener
    case lager
    case schwarzbier
    case altbier
    case kellerweizen
    case kolsch
    case tauchbier
    case steinbier
    case weizenbier
    case doradaPampeana
    case abbey
    case trappist
    case barleyWine
    case bitter
    case brownAle
    case indiaPaleAle
    case mild
    case paleAle
    case porter
    case scottishAle
    case stout
    case mildBeer
    case lambic
    case kriek
    case geuze
    case ale
    case witbier
}

extension BeerType {
    var formattedString: String {
        var res = ""
        for char in rawValue {
            if char.isUppercase {
                res += " "
            }
            res += String(char)
        }
        return res.capitalized
    }
}
