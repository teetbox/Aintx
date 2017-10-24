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
    
    func testInit() {
        XCTAssertEqual(aintx.base, fakeBase)
        XCTAssertEqual(aintx.config, .standard)
        XCTAssertEqual(aintx.httpMethod, .get)
        XCTAssertEqual(aintx.requestType, .data)
        XCTAssertEqual(aintx.responseType, .json)
    }
    
    func testInitWithEphemeralSession() {
        aintx = Aintx(base: fakeBase, config: .ephemeral)
        XCTAssertEqual(aintx.config, .ephemeral)
    }
    
    func testInitWithBackgroundSession() {
        aintx = Aintx(base: fakeBase, config: .background("#bg-1"))
        XCTAssertEqual(aintx.config, .background("#bg-1"))
    }
    
    func testGoPathWithDefaultSettings() {
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.httpMethod, .get)
            XCTAssertEqual(response.requestType, .data)
            XCTAssertEqual(response.responseType, .json)
            XCTAssertNil(response.queryString)
            XCTAssertNil(response.parameters)
        }
    }
    
    func testGoPathWithQueryString() {
        aintx.go(fakePath, queryString: ["key": "value"]) { (response) in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.queryString!, ["key": "value"])
        }
    }
    
    func testGoPathWithParameters() {
        let parameters = ["key": "value".data(using: .utf8)!]
        aintx.go(fakePath, parameters: parameters) { (response) in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.parameters!["key"] as! Data, "value".data(using: .utf8)!)
        }
    }
    
    func testGoPathWithHttpMethodPut() {
        aintx.httpMethod = .put
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.httpMethod, .put)
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .put) { (response) in
            XCTAssertEqual(response.httpMethod, .put)
        }
    }
    
    func testGoPathWithHttpMethodPost() {
        aintx.httpMethod = .post
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.httpMethod, .post)
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .post) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
        }
    }
    
    func testGoPathWithHttpMethodDelete() {
        aintx.httpMethod = .delete
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.httpMethod, .delete)
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .delete) { (response) in
            XCTAssertEqual(response.httpMethod, .delete)
        }
    }
    
    func testGoPathWithRequestTypeDownload() {
        aintx.requestType = .downLoad
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.requestType, .downLoad)
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .downLoad) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
        }
    }
    
    func testGoPathWithRequestTypeUpload() {
        aintx.requestType = .upload
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.requestType, .upload)
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .downLoad) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
        }
    }
    
    func testGoPathWithRequestTypeStream() {
        aintx.requestType = .stream
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.requestType, .stream)
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .stream) { (response) in
            XCTAssertEqual(response.requestType, .stream)
        }
    }
    
    func testGoWithResponseTypeData() {
        aintx.responseType = .data
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.responseType, .data)
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .data) { (response) in
            XCTAssertEqual(response.responseType, .data)
        }
    }
    
    func testGoWithResponseTypeImage() {
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.responseType, .image)
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .image) { (response) in
            XCTAssertEqual(response.responseType, .image)
        }
    }
    
    func testGoWithResponseTypeStream() {
        aintx.responseType = .stream
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.responseType, .stream)
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .stream) { (response) in
            XCTAssertEqual(response.responseType, .stream)
        }
    }
    
    func testGoWithHttpMethodAndRequestType() {
        aintx.httpMethod = .post
        aintx.requestType = .upload
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .upload)
        }
        
        aintx.httpMethod = .get
        aintx.responseType = .json
        aintx.go(fakePath, method: .post, requestType: .upload) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .upload)
        }
    }
    
    func testGoWithHttpMethodAndResponseType() {
        aintx.httpMethod = .post
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.responseType, .image)
        }
        
        aintx.httpMethod = .get
        aintx.responseType = .json
        aintx.go(fakePath, method: .post, responseType: .image) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.responseType, .image)
        }
    }
    
    func testGoWithRequestTypeAndResponseType() {
        aintx.requestType = .downLoad
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
            XCTAssertEqual(response.responseType, .image)
        }
        
        aintx.requestType = .data
        aintx.responseType = .json
        aintx.go(fakePath, requestType: .downLoad, responseType: .image) { (response) in
            XCTAssertEqual(response.requestType, .downLoad)
            XCTAssertEqual(response.responseType, .image)
        }
    }
    
    func testGoPathWithHttpMethodAndRequestTypeAndResponseType() {
        aintx.httpMethod = .post
        aintx.requestType = .downLoad
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .downLoad)
            XCTAssertEqual(response.responseType, .image)
        }
        
        aintx.httpMethod = .get
        aintx.requestType = .data
        aintx.responseType = .json
        aintx.go(fakePath, method: .put, requestType: .upload, responseType: .data) { (response) in
            XCTAssertEqual(response.httpMethod, .put)
            XCTAssertEqual(response.requestType, .upload)
            XCTAssertEqual(response.responseType, .data)
        }
    }
    
    func testGoPathWithAll() {
        aintx.go(fakePath, method: .post, requestType: .upload, responseType: .data, queryString: ["queryKey": "queryValue"], parameters: ["paramKey": "paramValue"]) { (response) in
            XCTAssertEqual(response.path, "/fake/path")
            XCTAssertEqual(response.httpMethod, .post)
            XCTAssertEqual(response.requestType, .upload)
            XCTAssertEqual(response.responseType, .data)
            XCTAssertEqual(response.queryString!, ["queryKey": "queryValue"])
            XCTAssertEqual(response.parameters!["paramKey"] as! String, "paramValue")
        }
    }
    
    func testGoRequest() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath)
        
        aintx.go(fakeRequest) { (response) in
            XCTAssertNil(response.data)
            XCTAssertNil(response.response)
            XCTAssertNil(response.error)
        }
    }
    
    func testCreateHttpRequest() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.base, aintx.base)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.httpMethod, aintx.httpMethod)
        XCTAssertEqual(fakeRequest.requestType, aintx.requestType)
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
