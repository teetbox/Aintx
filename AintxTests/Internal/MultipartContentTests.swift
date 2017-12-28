//
//  MultipartContentTests.swift
//  AintxTests
//
//  Created by Matt Tian on 27/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class MultipartContentTests: XCTestCase {
    
    var sut: MultipartContent!
    
    override func setUp() {
        super.setUp()

        sut = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: Data())
    }
    
    func testInitWithData() {
        XCTAssertEqual(sut.name, "file")
        XCTAssertEqual(sut.fileName, "swift.jpg")
        XCTAssertEqual(sut.type, "image/jpeg")
        XCTAssertEqual(sut.data, Data())
    }
    
    func testInitWithURL() {
        
    }
    
    func testContentType() {
        var contentType = ContentType.data
        XCTAssertEqual(contentType.rawValue, "application/octet-stream")
        
        contentType = ContentType.jpg
        XCTAssertEqual(contentType.rawValue, "image/jpeg")
        
        contentType = ContentType.png
        XCTAssertEqual(contentType.rawValue, "image/png")
    }
    
}
