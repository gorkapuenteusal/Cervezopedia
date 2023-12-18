//
//  BeerModelTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 14/12/23.
//

import XCTest
@testable import Cervezopedia

final class BeerModelTests: XCTestCase {
    var noNilImagePath: BeerModel?
    var beer: BeerModel!
    
    override func setUp() {
        super.setUp()
        noNilImagePath = BeerModel(name: "name", type: BeerType.Abbey, alcoholContent: 4.5, caloricIntake: 100, withImageName: "no_nil")
        beer = BeerModel(name: "name", type: BeerType.Abbey, alcoholContent: 4.5, caloricIntake: 100, withImageName: nil)
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
