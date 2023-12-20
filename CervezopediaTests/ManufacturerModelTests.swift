//
//  ManufacturerModelTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 14/12/23.
//

import XCTest
@testable import Cervezopedia

final class ManufacturerModelTests: XCTestCase {
    var wrongLocation: ManufacturerModel?
    var noNilLogoPath: ManufacturerModel?
    var national: ManufacturerModel!
    var imported: ManufacturerModel!
    
    override func setUp() {
        super.setUp()
        
        wrongLocation = ManufacturerModel(name: "wrongLocation", location: "wrong", logoName: "")
        noNilLogoPath = ManufacturerModel(name: "noNilLogoPath", location: "US", logoName: "no_nil")
        /// Manufacturador nacional. En este caso la simulación se ejectua como si el usuario fuese estadounidense
        national = ManufacturerModel(name: "national", location: "US", logoName: "")
        imported = ManufacturerModel(name: "imported", location: "ES", logoName: "")
    }
    
    func testWrongLocation() {
        XCTAssertNil(wrongLocation)
    }
    
    func testNoNilLogoPath() {
        XCTAssertNil(noNilLogoPath)
    }
    
    func testIsNational() {
        XCTAssertTrue(national.isNational())
        print(national.location)
    }
    
    func testIsImported() {
        XCTAssertFalse(imported.isNational())
        print(imported.location)
    }
    
    func testChangeToWrongLocation() {
        let oldValue = national.location
        national.location = "wrong"
        XCTAssertEqual(oldValue, national.location)
    }
    
    func testChangeToWrongImagePath() {
        let oldValue = national.logoName
        national.logoName = "no_nil"
        XCTAssertEqual(oldValue, national.logoName)
    }
    
    override func tearDown() {
        wrongLocation = nil
        noNilLogoPath = nil
        national = nil
        imported = nil
        
        super.tearDown()
    }
}
