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
    
    var sut: HttpRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()

        sut = Aintx(base: fakeBase).dataRequest(path: fakePath)
    }
    
    func testGo() {
        sut.go { response in
            XCTAssertNotNil(response)
        }
        
        let token = sut.go { _ in }
        XCTAssertNotNil(token)
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        sut = sut.setAuthorization(username: "username", password: "password")
        XCTAssertNotNil(sut)
    }
    
    func testSetAuthorizationWithBasicToken() {
        sut = sut.setAuthorization(basicToken: "Basic ABCDEFG")
        XCTAssertNotNil(sut)
    }
    
}
