//
//  AintxTests.swift
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

class AintxTests: XCTestCase {
    
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
        XCTAssertEqual(aintx.config, .default)
        XCTAssertEqual(aintx.httpMethod, .get)
        XCTAssertEqual(aintx.requestType, .data)
        XCTAssertEqual(aintx.responseType, .json)
    }
    
    func testInitWithEphemeralSession() {
        aintx = Aintx(base: fakeBase, config: .ephemeral)
        XCTAssertEqual(aintx.config, .ephemeral)
    }
    
    func testInitWithBackgroundSession() {
        aintx = Aintx(base: fakeBase, config: .background("background"))
        XCTAssertEqual(aintx.config, .background("background"))
    }
    
    func testGoPathWithDefaultSettings() {
        let exp = expectation(description: "exp")
        
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.httpMethod, .get)
            XCTAssertEqual(response.requestType, .data)
            XCTAssertEqual(response.responseType, .json)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testGoPathWithHttpMethodPost() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.httpMethod = .post
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.httpMethod, .post)
            exp.fulfill()
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .post) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoPathWithHttpMethodDelete() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.httpMethod = .delete
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.httpMethod, .delete)
            exp.fulfill()
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .delete) { (response) in
            XCTAssertEqual(response.httpMethod, .delete)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoPathWithRequestTypeDownload() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.requestType = .downLoad
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.requestType, .downLoad)
            exp.fulfill()
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .downLoad) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoPathWithRequestTypeUpload() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.requestType = .upload
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.requestType, .upload)
            exp.fulfill()
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .downLoad) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoPathWithRequestTypeStream() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.requestType = .stream
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.requestType, .stream)
            exp.fulfill()
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .stream) { (response) in
            XCTAssertEqual(response.requestType, .stream)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithResponseTypeData() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.responseType = .data
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.responseType, .data)
            exp.fulfill()
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .data) { (response) in
            XCTAssertEqual(response.responseType, .data)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithResponseTypeImage() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.responseType, .image)
            exp.fulfill()
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .image) { (response) in
            XCTAssertEqual(response.responseType, .image)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithResponseTypeStream() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.responseType = .stream
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.responseType, .stream)
            exp.fulfill()
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .stream) { (response) in
            XCTAssertEqual(response.responseType, .stream)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithHttpMethodAndRequestType() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.httpMethod = .post
        aintx.requestType = .upload
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .upload)
            exp.fulfill()
        }
        
        aintx.httpMethod = .get
        aintx.responseType = .json
        aintx.go(fakePath, method: .post, requestType: .upload) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .upload)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithHttpMethodAndResponseType() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.httpMethod = .post
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.responseType, .image)
            exp.fulfill()
        }
        
        aintx.httpMethod = .get
        aintx.responseType = .json
        aintx.go(fakePath, method: .post, responseType: .image) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.responseType, .image)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithRequestTypeAndResponseType() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.requestType = .downLoad
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
            XCTAssertEqual(response.responseType, .image)
            exp.fulfill()
        }
        
        aintx.requestType = .data
        aintx.responseType = .json
        aintx.go(fakePath, requestType: .downLoad, responseType: .image) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
            XCTAssertEqual(response.responseType, .image)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoPathWithHttpMethodAndRequestTypeAndResponseType() {
        let exp = expectation(description: "exp")
        let exp2 = expectation(description: "exp2")
        
        aintx.go(fakePath, method: .post, requestType: .downLoad, responseType: .image) { (response) in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .downLoad)
            XCTAssertEqual(response.responseType, .image)
            exp.fulfill()
        }
        
        aintx.httpMethod = .get
        aintx.requestType = .data
        
        aintx.go(fakePath, method: .post, requestType: .upload, responseType: .data) { (response) in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .upload)
            XCTAssertEqual(response.responseType, .data)
            exp2.fulfill()
        }
        
        wait(for: [exp, exp2], timeout: 1)
    }
    
    func testGoWithQueryString() {
        let exp = expectation(description: "exp")
        
        aintx.go(fakePath, queryString: ["fake": "queryString"]) { (response) in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.queryString!, ["fake": "queryString"])
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testGoRequest() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath)
        
        aintx.go(fakeRequest) { (response) in
            
        }
    }
    
    func testCreateHttpRequest() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.base, aintx.base)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.httpMethod, aintx.httpMethod)
        XCTAssertEqual(fakeRequest.requestType, aintx.requestType)
        XCTAssertEqual(fakeRequest.session, aintx.session)
    }
    
    func testCreateHttpRequestWithHttpMethod() {
        aintx.httpMethod = .post
        var fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        
        aintx.httpMethod = .get
        fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post) as! FakeRequest
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        
        aintx.httpMethod = .delete
        fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.httpMethod, .delete)
        
        aintx.httpMethod = .get
        fakeRequest = aintx.createHttpRequest(path: fakePath, method: .delete) as! FakeRequest
        XCTAssertEqual(fakeRequest.httpMethod, .delete)
    }
    
    func testCreateHttpRequestWithRequestType() {
        aintx.requestType = .downLoad
        var fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.requestType, .downLoad)
        
        aintx.requestType = .data
        fakeRequest = aintx.createHttpRequest(path: fakePath, requestType: .downLoad) as! FakeRequest
        XCTAssertEqual(fakeRequest.requestType, .downLoad)
        
        aintx.requestType = .upload
        fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.requestType, .upload)
        
        aintx.requestType = .data
        fakeRequest = aintx.createHttpRequest(path: fakePath, requestType: .upload) as! FakeRequest
        XCTAssertEqual(fakeRequest.requestType, .upload)
        
        aintx.requestType = .stream
        fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.requestType, .stream)
        
        aintx.requestType = .data
        fakeRequest = aintx.createHttpRequest(path: fakePath, requestType: .stream) as! FakeRequest
        XCTAssertEqual(fakeRequest.requestType, .stream)
    }
    
    func testCreateHttpRequestWithResponseType() {
        aintx.responseType = .data
        var fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.responseType, .data)
        
        aintx.responseType = .json
        fakeRequest = aintx.createHttpRequest(path: fakePath, responseType: .data) as! FakeRequest
        XCTAssertEqual(fakeRequest.responseType, .data)
        
        aintx.responseType = .image
        fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.responseType, .image)
        
        aintx.responseType = .json
        fakeRequest = aintx.createHttpRequest(path: fakePath, responseType: .image) as! FakeRequest
        XCTAssertEqual(fakeRequest.responseType, .image)
        
        aintx.responseType = .stream
        fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        XCTAssertEqual(fakeRequest.responseType, .stream)
        
        aintx.responseType = .json
        fakeRequest = aintx.createHttpRequest(path: fakePath, responseType: .stream) as! FakeRequest
        XCTAssertEqual(fakeRequest.responseType, .stream)
    }
    
    func testCreateHttpRequestWithHttpMethodAndRequestType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, requestType: .upload, queryString: ["fake": "queryString"], parameters: ["fake": "parameters"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        XCTAssertEqual(fakeRequest.requestType, .upload)
        XCTAssertEqual(fakeRequest.queryString!, ["fake": "queryString"])
        XCTAssertEqual(fakeRequest.parameters as! Dictionary, ["fake": "parameters"])
    }
    
    func testCreateHttpRequestWithHttpMethodAndResponseType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, responseType: .data, queryString: ["fake": "queryString"], parameters: ["fake": "parameters"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        XCTAssertEqual(fakeRequest.responseType, .data)
        XCTAssertEqual(fakeRequest.queryString!, ["fake": "queryString"])
        XCTAssertEqual(fakeRequest.parameters as! Dictionary, ["fake": "parameters"])
    }
    
    func testCreateHttpRequestWithRequestTypeAndResponseType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, requestType: .upload, responseType: .data, queryString: ["fake": "queryString"], parameters: ["fake": "parameters"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.requestType, .upload)
        XCTAssertEqual(fakeRequest.responseType, .data)
        XCTAssertEqual(fakeRequest.queryString!, ["fake": "queryString"])
        XCTAssertEqual(fakeRequest.parameters as! Dictionary, ["fake": "parameters"])
    }
    
    func testCreateHttpRequestWithHttpMethodAndRequestTypeAndResponseType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, requestType: .upload, responseType: .data, queryString: ["fake": "queryString"], parameters: ["fake": "parameters"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        XCTAssertEqual(fakeRequest.requestType, .upload)
        XCTAssertEqual(fakeRequest.responseType, .data)
        XCTAssertEqual(fakeRequest.queryString!, ["fake": "queryString"])
        XCTAssertEqual(fakeRequest.parameters as! Dictionary, ["fake": "parameters"])
    }
    
}
