//
//  ImageCacheTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import XCTest
@testable import Cervezopedia

final class ImageCacheTests: XCTestCase {
    lazy var sun: String = "sun.max"
    lazy var sunImage = UIImage(systemName: sun)!
    lazy var moon: String = "moon"
    lazy var moonImage = UIImage(systemName: moon)!
    lazy var heart = "heart"
    lazy var heartImage = UIImage(systemName: heart)!
    lazy var imageCache: ImageCache = ImageCache()
    
    func testNamesAndImagesInit() {
        imageCache = ImageCache(namesAndImages: [
            sun: sunImage,
            moon: moonImage,
            heart: heartImage
        ])
        
        XCTAssertTrue(imageCache.existsImage(withName: sun))
        XCTAssertTrue(imageCache.existsImage(withName: moon))
        XCTAssertTrue(imageCache.existsImage(withName: heart))
    }
    
    func testAddEntry() {
        XCTAssertTrue(imageCache.addEntry(withName: sun, andImage: sunImage))
        XCTAssertTrue(imageCache.existsImage(withName: sun))
    }
    
    func testRemoveEntryFailure() {
        XCTAssertFalse(imageCache.removeEntry(withName: sun))
    }
    
    func testRemoveEntrySuccess() {
        _ = imageCache.addEntry(withName: sun, andImage: sunImage)
        XCTAssertTrue(imageCache.removeEntry(withName: sun))
        XCTAssertFalse(imageCache.existsImage(withName: sun))
    }
    
    func testClear() {
        imageCache = ImageCache(namesAndImages: [
            sun: sunImage,
            moon: moonImage,
            heart: heartImage
        ])
        
        imageCache.clear()
        XCTAssertFalse(imageCache.existsImage(withName: sun))
        XCTAssertFalse(imageCache.existsImage(withName: moon))
        XCTAssertFalse(imageCache.existsImage(withName: heart))
    }
    
    override func tearDown() {
        imageCache.clear()
    }
}
