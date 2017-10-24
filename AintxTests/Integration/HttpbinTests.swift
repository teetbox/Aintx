//
//  HttpbinTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/24/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpbinTests: XCTestCase {

    var aintx: Aintx!
    
    override func setUp() {
        super.setUp()
        aintx = Aintx(base: "http://httpbin.org")
    }
    
    func testGet() {
        let asyncExpectation = expectation(description: "async")
        
        aintx.go("/get") { (httpResponse) in
            XCTAssertNil(httpResponse.error)
            XCTAssertNotNil(httpResponse.data)
            
            asyncExpectation.fulfill()
        }
        
        wait(for: [asyncExpectation], timeout: 5)
    }
    
    func testGetWithQueryString() {
        let asyncExpectation = expectation(description: "async")
        
        // https://httpbin.org/get?show_env=1
        aintx.go("/get", queryString: ["show_env": "1"]) { (httpResponse) in
            XCTAssertNil(httpResponse.error)
            XCTAssertNotNil(httpResponse.data)
            
            asyncExpectation.fulfill()
        }
        
        wait(for: [asyncExpectation], timeout: 5)
    }
    
    func testPost() {
        let asyncExpectation = expectation(description: "async")
        
        aintx.go("/post", method: .post) { (httpResponse) in
            XCTAssertNil(httpResponse.error)
            XCTAssertNotNil(httpResponse.data)
            
            asyncExpectation.fulfill()
        }
        
        wait(for: [asyncExpectation], timeout: 5)
    }
    
}
