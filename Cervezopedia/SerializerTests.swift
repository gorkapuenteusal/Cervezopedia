//
//  SerializerTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 14/12/23.
//

import XCTest
@testable import Cervezopedia

final class SerializerTests: XCTestCase {
    lazy var beer: BeerModel = BeerModel(name: "A beer", type: BeerType.Abbey, alcoholContent: 1, caloricIntake: 1, beerImageName: "")!
    lazy var beerList: [BeerModel] = [
        beer,
        BeerModel(name: "Another beer", type: BeerType.Altbier, alcoholContent: 2, caloricIntake: 2, beerImageName: "")!,
        BeerModel(name: "One more beer", type: BeerType.BarleyWine, alcoholContent: 3, caloricIntake: 3, beerImageName: "")!
    ]
    lazy var manufacturer: ManufacturerModel = ManufacturerModel(name: "A manufacturer", location: "US", logoName: "", beers: beerList)!
    lazy var manufacturerList: [ManufacturerModel] = [
        manufacturer,
        ManufacturerModel(
            name: "Another manufacturer",
            location: "AR", logoName: "",
            beers: [
                BeerModel(name: "Yet another beer", type: BeerType.Bitter, alcoholContent: 4, caloricIntake: 4, beerImageName: "")!,
                BeerModel(name: "One more to go", type: BeerType.Bock, alcoholContent: 5, caloricIntake: 5, beerImageName: "")!
            ]
        )!,
        ManufacturerModel(
            name: "One more manufacturer",
            location: "ES",
            logoName: "",
            beers: [
                BeerModel(name: "One more won't hurt", type: BeerType.BrownAle, alcoholContent: 6, caloricIntake: 6, beerImageName: "")!,
                BeerModel(name: "One more and we are bound", type: BeerType.DoradaPampeana, alcoholContent: 7, caloricIntake: 7, beerImageName: "")!
            ]
        )!
    ]
    
    func testSaveLoadBeer() {
        Serializer.shared.save(value: beer, key: beer.name)
        let loadedBeer: BeerModel = Serializer.shared.load(key: beer.name)!
        XCTAssertEqual(beer, loadedBeer)
    }
    
    func testSaveLoadBeerList() {
        Serializer.shared.save(value: beerList, key: "beers")
        let loadedBeerList: [BeerModel] = Serializer.shared.load(key: "beers")!
        XCTAssertEqual(beerList, loadedBeerList)
        XCTAssertEqual(beer, loadedBeerList.first!)
    }
    
    func testSaveLoadManufacturer() {
        Serializer.shared.save(value: manufacturer, key: "manufacturer")
        let loadedManufacturer: ManufacturerModel = Serializer.shared.load(key: "manufacturer")!
        XCTAssertEqual(manufacturer, loadedManufacturer)
        XCTAssertEqual(beerList, loadedManufacturer.beers)
        XCTAssertEqual(beer, loadedManufacturer.beers.first!)
    }
    
    func testSaveLoadManufacturerList() {
        Serializer.shared.save(value: manufacturerList, key: "manufacturerList")
        let loadedManufacturerList: [ManufacturerModel] = Serializer.shared.load(key: "manufacturerList")!
        XCTAssertEqual(manufacturerList, loadedManufacturerList)
        XCTAssertEqual(manufacturer, manufacturerList.first!)
        XCTAssertEqual(beerList, manufacturerList.first!.beers)
        XCTAssertEqual(beer, manufacturerList.first!.beers.first!)
    }
}
