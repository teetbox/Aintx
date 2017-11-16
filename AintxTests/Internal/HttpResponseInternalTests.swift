//
//  HttpResponseInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpResponseInternalTests: XCTestCase {
    
    var httpResponse: HttpResponse!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    func testInit() {
        httpResponse = HttpResponse()
        
        XCTAssertNil(httpResponse.data)
        XCTAssertNil(httpResponse.urlResponse)
        XCTAssertNil(httpResponse.error)
    }
    
    func testInitWithData() {
        httpResponse = HttpResponse(data: "some".data(using: .utf8), response: URLResponse(), error: nil)
        
        XCTAssertEqual(httpResponse.data, "some".data(using: .utf8))
        XCTAssertNotNil(httpResponse.urlResponse)
        XCTAssertNil(httpResponse.error)
    }
    
    func testInitWithFakeRequest() {
        let fakeRequest = FakeRequest(base: fakeBase, path: fakePath, params: ["paramKey": "paramValue"], method: .get, session: SessionManager.getSession(with: .standard))
        
        httpResponse = HttpResponse(fakeRequest: fakeRequest)
        
        XCTAssertEqual(httpResponse.fakeRequest!.path, "/fake/path")
        XCTAssertEqual(httpResponse.fakeRequest!.params!["paramKey"] as! String, "paramValue")
        XCTAssertEqual(httpResponse.fakeRequest!.method, .get)
    }
    
}
