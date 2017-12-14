//
//  HttpTaskTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpTaskTests: XCTestCase {
    
    var httpTask: HttpTask!
    
    override func setUp() {
        super.setUp()
        
        let aintx = Aintx(base: "www.fake.com")
        httpTask = aintx.get("/fake/path") { _ in }
    }
    
    override func tearDown() {
        httpTask = nil
    }
    
    func testInit() {
        let dataTask = httpTask as! HttpDataTask
        XCTAssertEqual(dataTask.sessionTask.state, .running)
    }
    
    func testSuspend() {
        httpTask.suspend()
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssertEqual(dataTask.sessionTask.state, .suspended)
    }
    
    func testResume() {
        httpTask.resume()
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssertEqual(dataTask.sessionTask.state, .running)
    }
    
    func testCancel() {
        httpTask.cancel()
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssertEqual(dataTask.sessionTask.state, .canceling)
    }
    
}
