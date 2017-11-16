//
//  AintxPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class AintxPublicTests: XCTestCase {
    
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }

    func testGet() {
        aintx.get(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.get(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.put(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.post(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.delete(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadWithURL() {
        aintx.upload(fakePath, fileURL: "/file/path") { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadWithData() {
        aintx.upload(fakePath, fileData: Data()) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testDownload() {
        aintx.download(fakePath) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testHttpRequest() {
        let request = aintx.httpRequest(path: fakePath)
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithParams() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"])
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithMethod() {
        let request = aintx.httpRequest(path: fakePath, method: .put)
        XCTAssertNotNil(request)
    }

    
    func testHttpRequestWithParamsAndMethod() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .get)
        XCTAssertNotNil(request)
    }
    
    func testFakeResponse() {
        aintx.fakeResponse = HttpResponse(data: "data".data(using: .utf8))
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.data, "data".data(using: .utf8))
        }
    }
    
}
