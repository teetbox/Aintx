//
//  RequestTokenInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class RequestTokenInternalTests: XCTestCase {
    
    var requestToken: RequestToken!
    
    override func setUp() {
        super.setUp()
        
        let aintx = Aintx(base: "www.fake.com")
        requestToken = aintx.get("/fake/path") { _ in }
    }
    
    func testInit() {
        XCTAssertEqual(requestToken.task.state, .running)
    }
    
    func testSuspend() {
        requestToken.suspend()
        XCTAssertEqual(requestToken.task.state, .suspended)
    }
    
    func testResume() {
        requestToken.resume()
        XCTAssertEqual(requestToken.task.state, .running)
    }
    
    func testCancel() {
        requestToken.cancel()
        XCTAssertEqual(requestToken.task.state, .canceling)
    }
    
}
