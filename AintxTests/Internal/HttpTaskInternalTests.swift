//
//  HttpTaskInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpTaskInternalTests: XCTestCase {
    
    var httpTask: HttpTask!
    
    override func setUp() {
        super.setUp()
        
        let aintx = Aintx(base: "www.fake.com")
        httpTask = aintx.get("/fake/path") { _ in }
    }
    
    func testInit() {
        XCTAssertEqual(httpTask.sessionTask.state, .running)
    }
    
    func testSuspend() {
        httpTask.suspend()
        XCTAssertEqual(httpTask.sessionTask.state, .suspended)
    }
    
    func testResume() {
        httpTask.resume()
        XCTAssertEqual(httpTask.sessionTask.state, .running)
    }
    
    func testCancel() {
        httpTask.cancel()
        XCTAssertEqual(httpTask.sessionTask.state, .canceling)
    }
    
}
