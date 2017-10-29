//
//  HttpRequestInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpRequestInternalTests: XCTestCase {
    
    var httpRequest: HttpDataRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        httpRequest = HttpDataRequest(base: fakeBase, path: fakePath, params: nil, method: .get, session: URLSession.shared)
    }
    
    func testInit() {
        XCTAssertEqual(httpRequest.base, fakeBase)
        XCTAssertEqual(httpRequest.path, fakePath)
        XCTAssertEqual(httpRequest.method, .get)
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        let loginString = "username:password"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        _ = httpRequest.setAuthorization(username: "username", password: "password")
        
        XCTAssertEqual(httpRequest.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
    }
    
    func testSetAuthorizationWithBasicToken() {
        _ = httpRequest.setAuthorization(basicToken: "ABC")
        
        XCTAssertEqual(httpRequest.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic ABC")
    }
    
}
