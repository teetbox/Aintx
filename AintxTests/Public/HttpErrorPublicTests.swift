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
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
    }
    
    func testDataRequestInBackgroundSession() {
        aintx = Aintx(base: fakeBase, config: .background("bg"))
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.error?.localizedDescription, "Data tasks are not supported in background session")
        }
    }
    
    func testInvalidURL() {

    }
    
}
