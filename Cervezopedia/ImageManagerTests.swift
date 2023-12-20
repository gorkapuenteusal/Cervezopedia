//
//  ImageManagerTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import XCTest
import UIKit
@testable import Cervezopedia

final class ImageManagerTests: XCTestCase {
    lazy var wrongPathManager = ImageManager(imagePath: URL(fileURLWithPath: "wrong"))
    lazy var manager = ImageManager(imagePath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    lazy var sun = "sun"
    lazy var sunImage = UIImage(systemName: "sun.max")!
    lazy var moon = "moon"
    lazy var moonImage = UIImage(systemName: moon)!
    lazy var heart = "heart"
    lazy var heartImage = UIImage(systemName: heart)!
    
    func testSaveFailureRetreivingData() {
        let invalidImage: UIImage = UIImage()
        XCTAssertFalse(manager.saveImage(image: invalidImage, withName: "wrong"))
    }
    
    func testSaveFailureWriting() {
        XCTAssertFalse(wrongPathManager.saveImage(image: sunImage, withName: sun))
    }
    
    func testSaveSucces() {
        XCTAssertTrue(manager.saveImage(image: sunImage, withName: sun))
        XCTAssertTrue(manager.existsImage(withName: sun))
    }
    
    func testRemoveImageFailureWrongPath() {
        XCTAssertFalse(wrongPathManager.removeImage(withName: "wrong"))
    }
    
    func testRemoveImageFailureNoSuchFile() {
        XCTAssertFalse(manager.removeImage(withName: "wrong"))
    }
    
    func testRemoveImageSuccess() {
        _ = manager.saveImage(image: sunImage, withName: sun)
        XCTAssertTrue(manager.removeImage(withName: sun))
        XCTAssertFalse(manager.existsImage(withName: sun))
    }
    
    func testClearImages() {
        saveTheThreeImages()
        
        manager.clearImages()
        
        XCTAssertFalse(manager.existsImage(withName: sun))
        XCTAssertFalse(manager.existsImage(withName: moon))
        XCTAssertFalse(manager.existsImage(withName: heart))
    }
    
    func testGetNamesAndImagesFailure() {
        XCTAssertEqual([:], wrongPathManager.getNamesAndImages())
    }
    
    func testGetNamesAndImagesSuccess() {
        saveTheThreeImages()
        let namesAndImagesData = [
            sun: sunImage,
            moon: moonImage,
            heart: heartImage
        ]
        
        XCTAssertEqual(namesAndImagesData.keys, manager.getNamesAndImages().keys)
    }
    
    override func tearDown() {
        manager.clearImages()
    }
    
    private func saveTheThreeImages() {
        _ = manager.saveImage(image: sunImage, withName: sun)
        _ = manager.saveImage(image: moonImage, withName: moon)
        _ = manager.saveImage(image: heartImage, withName: heart)
    }
}
