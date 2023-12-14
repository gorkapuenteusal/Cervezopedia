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
        noNilImagePath = BeerModel(name: "name", type: BeerType.Abbey, alcoholContent: 4.5, caloricIntake: 100, imagePath: "no_nil")
        beer = BeerModel(name: "name", type: BeerType.Abbey, alcoholContent: 4.5, caloricIntake: 100, imagePath: nil)
    }
    
    func testWrongImagePath() {
        XCTAssertNil(noNilImagePath)
    }
    
    func testChangeToWrongImagePath() {
        let oldValue = beer.imagePath
        beer.imagePath = "no_nil"
        XCTAssertEqual(oldValue, beer.imagePath)
    }
    
    override func tearDown() {
        noNilImagePath = nil
        super.tearDown()
    }
}