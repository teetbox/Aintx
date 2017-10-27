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
    
    func testSetAuthorizationWithUsernameAndPassword() {
        httpRequest.setAuthorization(username: "username", password: "password")
        
        let loginString = "username:password"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        XCTAssertEqual(httpRequest.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
    }
    
    func testSetAuthorizationWithBasicToken() {
        let token = "abc"
        _ = httpRequest.setAuthorization(basicToken: token)
        
        XCTAssertEqual(httpRequest.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic \(token)")
    }
    
}
