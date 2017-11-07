//
//  RequestTokenPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class RequestTokenPublicTests: XCTestCase {
    
    var requestToken: RequestToken!
    
    override func setUp() {
        super.setUp()
        
        let aintx = Aintx(base: "www.fake.com")
        requestToken = aintx.get("/fake/path") { _ in }
    }
    
    func testInit() {
        XCTAssertNotNil(requestToken)
    }

    func testSuspend() {
        requestToken.suspend()
    }
    
    func testResume() {
        requestToken.resume()
    }
    
    func testCancel() {
        requestToken.cancel()
    }
    
}
