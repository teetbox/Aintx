//
//  HttpResponseTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpResponseTests: XCTestCase {
    
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
    
    func testInitWithError() {
        let httpError = HttpError.requestFailed(.invalidURL("/faka/path"))
        httpResponse = HttpResponse(data: nil, response: nil, error: httpError)
        
        XCTAssertNil(httpResponse.data)
        XCTAssertNil(httpResponse.urlResponse)
        XCTAssertNotNil(httpResponse.error)
        XCTAssertEqual(httpResponse.error!.localizedDescription, httpError.localizedDescription)
    }
    
    func testInitWithFakeRequest() {
        let fakeRequest = FakeHttpRequest(base: fakeBase, path: fakePath, method: .get, params: ["paramKey": "paramValue"], sessionConfig: .standard)
        
        httpResponse = HttpResponse(fakeRequest: fakeRequest)
        
        XCTAssertEqual(httpResponse.fakeRequest!.path, "/fake/path")
        XCTAssertEqual(httpResponse.fakeRequest!.params!["paramKey"] as! String, "paramValue")
        XCTAssertEqual(httpResponse.fakeRequest!.method, .get)
    }
    
}
