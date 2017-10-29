//
//  AintxInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/24/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class AintxInternalTests: XCTestCase {
    
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
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testGetWithRequestType() {
        aintx.get(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.get(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.get(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testGetWithParamsAndType() {
        aintx.get(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
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
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testPutWithRequestType() {
        aintx.put(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.put(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.put(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testPutWithParamsAndType() {
        aintx.put(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
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
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testPostWithRequestType() {
        aintx.post(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.post(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.post(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testPostWithParamsAndType() {
        aintx.post(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
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
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testDeleteWithRequestType() {
        aintx.delete(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
        
        aintx.delete(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .stream)
        }
        
        aintx.delete(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.type, .upload)
        }
    }
    
    func testDeleteWithParamsAndType() {
        aintx.delete(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.type, .downLoad)
        }
    }
    
}