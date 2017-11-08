//
//  HttpErrorPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 08/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpErrorPublicTests: XCTestCase {
    
    var aintx: Aintx!
    let fakeBase = "http://www.fake.com"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }
    
    func testInvalidURL() {
        aintx.get("/~!@#$") { response in
            let error = response.error
            XCTAssertEqual(error?.localizedDescription, "Invalid URL: '\(self.fakeBase)/~!@#$'")
        }
    }
    
}
