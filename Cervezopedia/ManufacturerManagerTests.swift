//
//  ManufacturerManagerTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 16/12/23.
//

import XCTest
@testable import Cervezopedia

final class ManufacturerManagerTests: XCTestCase {
    let manager = ManufacturerManager.shared
    lazy var manufacturer = ManufacturerModel(name: "A manufacturer", location: "US", logoPath: nil)!
    lazy var sameManufacturer = ManufacturerModel(name: "A manufacturer", location: "US", logoPath: nil)!
    lazy var differentManufacturer = ManufacturerModel(name: "Another manufacturer", location: "ES", logoPath: nil)!
    lazy var sameDifferentManufacturer = ManufacturerModel(name: "Another manufacturer", location: "ES", logoPath: nil)!
    
    override func setUp() {
        super.setUp()
        _ = manager.add(toAdd: manufacturer)
    }
    
    func testAddFail() {
        XCTAssertFalse(manager.add(toAdd: sameManufacturer))
    }
    
    func testAddSucces() {
        XCTAssertTrue(manager.add(toAdd: differentManufacturer))
    }
    
    func testEditFailSameId() {
        _ = manager.add(toAdd: differentManufacturer)
        XCTAssertFalse(manager.edit(toEdit: differentManufacturer, edited: sameManufacturer))
    }
    
    func testEditFailNotFound() {
        XCTAssertFalse(manager.edit(toEdit: differentManufacturer, edited: sameDifferentManufacturer))
    }
    
    func testEditSuccesSameId() {
        XCTAssertTrue(manager.edit(toEdit: manufacturer, edited: sameManufacturer))
    }
    
    func testEditSuccesDifferentId() {
        XCTAssertTrue(manager.edit(toEdit: manufacturer, edited: differentManufacturer))
    }
    
    func testRemoveFail() {
        XCTAssertFalse(manager.remove(toRemove: differentManufacturer))
    }
    
    func testRemoveSucces() {
        XCTAssertTrue(manager.remove(toRemove: manufacturer))
    }
    
    func testClear() {
        manager.clear()
        XCTAssertTrue(manager.isEmpty())
    }
    
    override func tearDown() {
        manager.clear()
        super.tearDown()
    }
}
