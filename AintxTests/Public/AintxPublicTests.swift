//
//  AintxPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

extension SessionConfig: Equatable {
    public static func ==(lhs: SessionConfig, rhs: SessionConfig) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

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
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testGetWithType() {
        aintx.get(fakePath, type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.get(fakePath, type: .stream) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.get(fakePath, type: .upload) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testGetWithParamsAndType() {
        aintx.get(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testPutWithType() {
        aintx.put(fakePath, type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.put(fakePath, type: .stream) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.put(fakePath, type: .upload) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testPutWithParamsAndType() {
        aintx.put(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testPostWithType() {
        aintx.post(fakePath, type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.post(fakePath, type: .stream) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.post(fakePath, type: .upload) { (response) in
           XCTAssertNotNil(response)
        }
    }
    
    func testPostWithParamsAndType() {
        aintx.post(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testDeleteWithType() {
        aintx.delete(fakePath, type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.delete(fakePath, type: .stream) { (response) in
            XCTAssertNotNil(response)
        }
        
        aintx.delete(fakePath, type: .upload) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testDeleteWithParamsAndType() {
        aintx.delete(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testHttpRequest() {
        aintx.httpRequest(path: fakePath).go { (response) in
            XCTAssertNotNil(response)
        }
    }
    
    func testHttpRequestWithParams() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"])
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithMethod() {
        let request = aintx.httpRequest(path: fakePath, method: .put)
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithType() {
        let request = aintx.httpRequest(path: fakePath, type: .data)
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithParamsAndMethod() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .get)
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithParamsAndType() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"], type: .data)
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithMethodAndType() {
        let request = aintx.httpRequest(path: fakePath, method: .delete, type: .data)
        XCTAssertNotNil(request)
    }
    
    func testHttpRequestWithParamsAndMethodAndType() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .post, type: .upload)
        XCTAssertNotNil(request)
    }
    
}
