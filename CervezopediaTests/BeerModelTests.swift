//
//  BeerModelTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 14/12/23.
//

import XCTest
@testable import Cervezopedia

final class BeerModelTests: XCTestCase { // TODO: - Añadir tests para fotos que existan y que no existan
    var noNilImagePath: BeerModel?
    var beer: BeerModel!
    
    override func setUp() {
        super.setUp()
        noNilImagePath = BeerModel(name: "name", type: BeerType.Abbey, alcoholContent: 4.5, caloricIntake: 100, beerImageName: "no_nil")
        beer = BeerModel(name: "name", type: BeerType.Abbey, alcoholContent: 4.5, caloricIntake: 100, beerImageName: "")
    }
    
    func testWrongImagePath() {
        XCTAssertNil(noNilImagePath)
    }
    
    func testChangeToWrongImagePath() {
        let oldValue = beer.beerImageName
        beer.beerImageName = "no_nil"
        XCTAssertEqual(oldValue, beer.beerImageName)
    }
    
    override func tearDown() {
        noNilImagePath = nil
        super.tearDown()
    }
}
