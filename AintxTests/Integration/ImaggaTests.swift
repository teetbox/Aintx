//
//  ImaggaTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class ImaggaTests: XCTestCase {
    
    var aintx: Aintx!
    var asyncExpectation: XCTestExpectation!
    
    let API_Key = "acc_f204118321e5ff9"
    let API_Secret = "374a892e7f89aaadcd7c98cc63f208b2"
    let Basic_Token = "Basic YWNjX2YyMDQxMTgzMjFlNWZmOTozNzRhODkyZTdmODlhYWFkY2Q3Yzk4Y2M2M2YyMDhiMg=="
    
    override func setUp() {
        super.setUp()

        aintx = Aintx(base: "https://api.imagga.com")
        asyncExpectation = expectation(description: "async")
    }
    
    func testGet() {
        let path = "/v1/tagging"
        let queryDic = ["url": "http://imagga.com/static/images/tagging/wind-farm-538576_640.jpg"]
        
        var request = aintx.createHttpRequest(path: path, queryDic: queryDic)
        request.authToken = Basic_Token
        
        aintx.go(request) { (response) in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            self.asyncExpectation.fulfill()
        }
        
        wait(for: [asyncExpectation], timeout: 30)
    }
    
}
