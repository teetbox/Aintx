//
//  AintxInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/24/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

extension SessionConfig: Equatable {
    public static func ==(lhs: SessionConfig, rhs: SessionConfig) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

class AintxInternalTests: XCTestCase {
    
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }
    
    
    func testInit() {
        XCTAssertEqual(aintx.base, fakeBase)
        XCTAssertEqual(aintx.config, .standard)
        XCTAssertEqual(aintx.session, URLSession.shared)
    }
    
    func testInitWithConfig() {
        aintx = Aintx(base: fakeBase, config: .ephemeral)
        XCTAssertEqual(aintx.config, .ephemeral)
        
        aintx = Aintx(base: fakePath, config: .background("bg"))
        XCTAssertEqual(aintx.config, .background("bg"))
    }
    
    func testGet() {
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.get(fakePath) { _ in }
        XCTAssertNotNil(token.task)
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .get)
        }
    }
    
    func testGetWithType() {
        aintx.get(fakePath, type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.get(fakePath, type: .stream) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.get(fakePath, type: .upload) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testGetWithParamsAndType() {
        aintx.get(fakePath, params: ["key": "value"], type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.put(fakePath) { _ in }
        XCTAssertNotNil(token.task)
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .put)
        }
    }
    
    func testPutWithType() {
        aintx.put(fakePath, type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.put(fakePath, type: .stream) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.put(fakePath, type: .upload) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testPutWithParamsAndType() {
        aintx.put(fakePath, params: ["key": "value"], type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.post(fakePath) { _ in }
        XCTAssertNotNil(token.task)
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .post)
        }
    }
    
    func testPostWithType() {
        aintx.post(fakePath, type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.post(fakePath, type: .stream) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.post(fakePath, type: .upload) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testPostWithParamsAndType() {
        aintx.post(fakePath, params: ["key": "value"], type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.delete(fakePath) { _ in }
        XCTAssertNotNil(token.task)
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
        }
    }
    
    func testDeleteWithType() {
        aintx.delete(fakePath, type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.delete(fakePath, type: .stream) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.delete(fakePath, type: .upload) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testDeleteWithParamsAndType() {
        aintx.delete(fakePath, params: ["key": "value"], type: .downLoad) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
    }
    
    func testHttpRequest() {
        let request = aintx.httpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.type, .data)
        XCTAssertNil(request.params)
    }
    
    func testHttpRequestWithParams() {
        let request = aintx.httpRequest(path: fakePath, params: ["key": "value"]) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
    }
    
    func testHttpRequestWithMethod() {
        var request: FakeRequest
        
        request = aintx.httpRequest(path: fakePath, method: .put) as! FakeRequest
        XCTAssertEqual(request.method, .put)

        request = aintx.httpRequest(path: fakePath, method: .post) as! FakeRequest
        XCTAssertEqual(request.method, .post)
        
        request = aintx.httpRequest(path: fakePath, method: .delete) as! FakeRequest
        XCTAssertEqual(request.method, .delete)
    }
    
    func testHttpRequestWithType() {
        var request: FakeRequest
        
        request = aintx.httpRequest(path: fakePath, type: .downLoad) as! FakeRequest
        XCTAssertEqual(request.type, .downLoad)
        
        request = aintx.httpRequest(path: fakePath, type: .upload) as! FakeRequest
        XCTAssertEqual(request.type, .upload)
        
        request = aintx.httpRequest(path: fakePath, type: .stream) as! FakeRequest
        XCTAssertEqual(request.type, .stream)
    }
    
    func testHttpRequestWithParamsAndMethod() {
        var request: FakeRequest
        
        request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .put) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.method, .put)
        
        request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .delete) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.method, .delete)
    }
    
    func testHttpRequestWithParamsAndType() {
        var request: FakeRequest
        
        request = aintx.httpRequest(path: fakePath, params: ["key": "value"], type: .upload) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.type, .upload)
        
        request = aintx.httpRequest(path: fakePath, params: ["key": "value"], type: .downLoad) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.type, .downLoad)
    }
    
    func testHttpRequestWithMethodAndType() {
        var request: FakeRequest
        
        request = aintx.httpRequest(path: fakePath, method: .put, type: .upload) as! FakeRequest
        XCTAssertEqual(request.method, .put)
        XCTAssertEqual(request.type, .upload)
        
        request = aintx.httpRequest(path: fakePath, method: .delete, type: .data) as! FakeRequest
        XCTAssertEqual(request.method, .delete)
        XCTAssertEqual(request.type, .data)
    }
    
    func testHttpRequestWithParamsAndMethodAndType() {
        var request: FakeRequest
        
        request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .post, type: .upload) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.type, .upload)
        
        request = aintx.httpRequest(path: fakePath, params: ["key": "value"], method: .delete, type: .data) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.method, .delete)
        XCTAssertEqual(request.type, .data)
    }
    
}
