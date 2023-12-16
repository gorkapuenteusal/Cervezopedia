//
//  ManufacturerManager.swift
//  Cervezopedia
//
//  Created by Gorka Puente Díez on 16/12/23.
//

import Foundation

final class ManufacturerManager: ObservableObject {
    static let shared = ManufacturerManager()
    
    @Published var manufacturers: [ManufacturerModel] = []
    
    private init() {}
    
    func add(toAdd: ManufacturerModel) -> Bool {
        if manufacturers.contains(where: { $0 == toAdd } ) { return false }
        manufacturers.append(toAdd)
        return true
    }
    
    func edit(toEdit: ManufacturerModel, edited: ManufacturerModel) -> Bool {
        if manufacturers.contains(where: { $0 != toEdit && $0 == edited } ) { return false }
        if let index = manufacturers.firstIndex(where: { $0 == toEdit }) {
            manufacturers[index].id = edited.id
            manufacturers[index].name = edited.name
            manufacturers[index].location = edited.location
            manufacturers[index].logoPath = edited.logoPath
            manufacturers[index].beers = edited.beers
            return true
        }
        return false
    }
    
    func remove(toRemove: ManufacturerModel) -> Bool {
        if let index = manufacturers.firstIndex(where: { $0 == toRemove }) {
            manufacturers.remove(at: index)
            return true
        }
        return false
    }
    
    func clear() {
        manufacturers.removeAll()
    }
    
    func isEmpty() -> Bool {
        return manufacturers.isEmpty
    }
}
