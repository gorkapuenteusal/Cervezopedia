//
//  ImageCacheEntryTests.swift
//  CervezopediaTests
//
//  Created by Gorka Puente Díez on 18/12/23.
//

import XCTest
@testable import Cervezopedia

final class ImageCacheEntryTests: XCTestCase {
    let image: UIImage = UIImage(systemName: "photo")!
    lazy var failedEntry: ImageCacheEntry? = ImageCacheEntry(name: nil, image: nil)
    lazy var noNameEntry: ImageCacheEntry = ImageCacheEntry(name: nil, image: image)!
    lazy var noImageEntry: ImageCacheEntry = ImageCacheEntry(name: "image", image: nil)!
    lazy var entry: ImageCacheEntry = ImageCacheEntry(name: "image", image: image)!
    
    func testEntryFail() {
        XCTAssertNil(failedEntry)
    }
    
    func testNoNameEntrySuccess() {
        XCTAssertEqual(image.description, noNameEntry.name)
    }
    
    func testNoImageEntrySuccess() {
        XCTAssertNotNil(noImageEntry)
        XCTAssertNil(noImageEntry.image)
    }
    
    func testEntrySuccess() {
        XCTAssertNotNil(entry)
    }

}
