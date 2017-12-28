//
//  MultiPartContentPublicTests.swift
//  AintxTests
//
//  Created by Matt Tian on 27/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class MultiPartContentPublicTests: XCTestCase {
    
    var sut: MultiPartContent!
    
    func testInitWithData() {
        sut = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: Data())
        XCTAssertNotNil(sut)
    }
    
    func testInitWithURL() {
        let fileURL = URL(string: "/upload/swift.jpg")!
        sut = MultiPartContent(name: "file", type: .jpg, url: fileURL)
        XCTAssertNotNil(sut)
    }
    
}
