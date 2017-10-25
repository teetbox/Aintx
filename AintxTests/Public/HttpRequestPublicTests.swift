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
        httpRequest = aintx.createHttpRequest(path: fakePath)
    }
    
    func testGo() {
        httpRequest.go { (response) in
            XCTAssertEqual(response.fakeRequest!.base, "http://www.fake.com")
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
        }
    }
    
    func testSetAuthorization() {
        let token = "access-token"
        httpRequest.setAuthorization(token)
        
        XCTAssertEqual(httpRequest.authToken, token)
    }

}
