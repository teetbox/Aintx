//
//  HttpTaskPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpTaskPublicTests: XCTestCase {
    
    var httpTask: HttpTask!
    
    override func setUp() {
        super.setUp()
        
        let aintx = Aintx(base: "www.fake.com")
        httpTask = aintx.get("/fake/path") { _ in }
    }
    
    func testInit() {
        XCTAssertNotNil(httpTask)
    }

    func testSuspend() {
        httpTask.suspend()
    }
    
    func testResume() {
        httpTask.resume()
    }
    
    func testCancel() {
        httpTask.cancel()
    }
    
}
