//
//  SerializerTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 14/12/23.
//

import XCTest
@testable import Cervezopedia

final class SerializerTests: XCTestCase {
    func testSaveLoadBeer() {
        let beer = BeerModel(name: "beer", type: BeerType.PaleAle, alcoholContent: 4.5, caloricIntake: 100, imagePath: nil)!
        Serializer.shared.save(value: beer, key: beer.name)
        let loadedBeer: BeerModel = Serializer.shared.load(key: beer.name)!
        XCTAssertEqual(beer, loadedBeer)
    }
    
    func testSaveLoadBeerList() {
        let beerList = [
            BeerModel(name: "beer1", type: BeerType.Abbey, alcoholContent: 1, caloricIntake: 1, imagePath: nil),
            BeerModel(name: "beer2", type: BeerType.Altbier, alcoholContent: 2, caloricIntake: 2, imagePath: nil),
            BeerModel(name: "beer3", type: BeerType.BarleyWine, alcoholContent: 3, caloricIntake: 3, imagePath: nil)
        ]
        Serializer.shared.save(value: beerList, key: "beers")
        let loadedBeerList: [BeerModel] = Serializer.shared.load(key: "beers")!
        XCTAssertEqual(beerList, loadedBeerList)
    }
}
