//
//  HttpRequestPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 23/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpRequestPublicTests: XCTestCase {
    
    var httpRequest: HttpRequest!
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
        httpRequest = aintx.httpRequest(path: fakePath)
    }
    
    func testGo() {
        httpRequest.go { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        httpRequest = httpRequest.setAuthorization(username: "username", password: "password")
        XCTAssertNotNil(httpRequest)
    }
    
    func testSetAuthorizationWithBasicToken() {
        httpRequest = httpRequest.setAuthorization(basicToken: "Basic ABC")
        XCTAssertNotNil(httpRequest)
    }
    
}
