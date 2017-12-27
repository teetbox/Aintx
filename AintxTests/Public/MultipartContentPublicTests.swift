//
//  MultipartContentPublicTests.swift
//  AintxTests
//
//  Created by Matt Tian on 27/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class MultipartContentPublicTests: XCTestCase {
    
    var sut: MultipartContent!
    
    func testInitWithData() {
        sut = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: Data())
        XCTAssertNotNil(sut)
    }
    
    func testInitWithURL() {
        
    }
    
}
