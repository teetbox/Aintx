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
        XCTAssertEqual(aintx.requestType, .data)
        XCTAssertEqual(aintx.responseType, .json)
    }
    
    func testGoPath() {
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.requestType, .data)
            XCTAssertEqual(response.fakeRequest!.responseType, .json)
            XCTAssertNil(response.fakeRequest!.queryDic)
            XCTAssertNil(response.fakeRequest!.params)
        }
    }
    
    func testGet() {
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.requestType, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testGetWithRequestType() {
        aintx.get(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
        
        aintx.get(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.requestType, .stream)
        }
        
        aintx.get(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
    }
    
    func testGetWithParamsAndType() {
        aintx.get(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .get)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.requestType, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testPutWithRequestType() {
        aintx.put(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
        
        aintx.put(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.requestType, .stream)
        }
        
        aintx.put(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
    }
    
    func testPutWithParamsAndType() {
        aintx.put(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.requestType, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testPostWithRequestType() {
        aintx.post(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
        
        aintx.post(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .stream)
        }
        
        aintx.post(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
    }
    
    func testPostWithParamsAndType() {
        aintx.post(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.requestType, .data)
            XCTAssertNil(response.fakeRequest!.params)
        }
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testDeleteWithRequestType() {
        aintx.delete(fakePath, type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
        
        aintx.delete(fakePath, type: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
            XCTAssertEqual(response.fakeRequest!.requestType, .stream)
        }
        
        aintx.delete(fakePath, type: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
    }
    
    func testDeleteWithParamsAndType() {
        aintx.delete(fakePath, params: ["key": "value"], type: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
    }
    
    func testGoPathWithQueryString() {
        aintx.go(fakePath, queryDic: ["key": "value"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.queryDic!, ["key": "value"])
        }
    }
    
    func testGoPathWithParameters() {
        let paramDic = ["key": "value".data(using: .utf8)!]
        aintx.go(fakePath, params: paramDic) { (response) in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! Data, "value".data(using: .utf8)!)
        }
    }
    
    func testGoPathWithHttpMethodPut() {
        aintx.httpMethod = .put
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .put) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
        }
    }
    
    func testGoPathWithHttpMethodPost() {
        aintx.httpMethod = .post
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .post) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
        }
    }
    
    func testGoPathWithHttpMethodDelete() {
        aintx.httpMethod = .delete
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
        }
        
        aintx.httpMethod = .get
        aintx.go(fakePath, method: .delete) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .delete)
        }
    }
    
    func testGoPathWithRequestTypeDownload() {
        aintx.requestType = .downLoad
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
    }
    
    func testGoPathWithRequestTypeUpload() {
        aintx.requestType = .upload
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .downLoad) { (response) in
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
        }
    }
    
    func testGoPathWithRequestTypeStream() {
        aintx.requestType = .stream
        aintx.go(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.requestType, .stream)
        }
        
        aintx.requestType = .data
        aintx.go(fakePath, requestType: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.requestType, .stream)
        }
    }
    
    func testGoWithResponseTypeData() {
        aintx.responseType = .data
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.responseType, .data)
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .data) { (response) in
            XCTAssertEqual(response.fakeRequest!.responseType, .data)
        }
    }
    
    func testGoWithResponseTypeImage() {
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .image) { (response) in
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
    }
    
    func testGoWithResponseTypeStream() {
        aintx.responseType = .stream
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.responseType, .stream)
        }
        
        aintx.responseType = .json
        aintx.go(fakePath, responseType: .stream) { (response) in
            XCTAssertEqual(response.fakeRequest!.responseType, .stream)
        }
    }
    
    func testGoWithHttpMethodAndRequestType() {
        aintx.httpMethod = .post
        aintx.requestType = .upload
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
        
        aintx.httpMethod = .get
        aintx.responseType = .json
        aintx.go(fakePath, method: .post, requestType: .upload) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
        }
    }
    
    func testGoWithHttpMethodAndResponseType() {
        aintx.httpMethod = .post
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
        
        aintx.httpMethod = .get
        aintx.responseType = .json
        aintx.go(fakePath, method: .post, responseType: .image) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
    }
    
    func testGoWithRequestTypeAndResponseType() {
        aintx.requestType = .downLoad
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
        
        aintx.requestType = .data
        aintx.responseType = .json
        aintx.go(fakePath, requestType: .downLoad, responseType: .image) { (response) in
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
    }
    
    func testGoPathWithHttpMethodAndRequestTypeAndResponseType() {
        aintx.httpMethod = .post
        aintx.requestType = .downLoad
        aintx.responseType = .image
        aintx.go(fakePath) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .downLoad)
            XCTAssertEqual(response.fakeRequest!.responseType, .image)
        }
        
        aintx.httpMethod = .get
        aintx.requestType = .data
        aintx.responseType = .json
        aintx.go(fakePath, method: .put, requestType: .upload, responseType: .data) { (response) in
            XCTAssertEqual(response.fakeRequest!.httpMethod, .put)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
            XCTAssertEqual(response.fakeRequest!.responseType, .data)
        }
    }
    
    func testGoPathWithHttpMethodAndRequestTypeAndResponseTypeAndQueryStringAndParameters() {
        aintx.go(fakePath, method: .post, requestType: .upload, responseType: .data, queryDic: ["queryKey": "queryValue"], params: ["paramKey": "paramValue"]) { (response) in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
            XCTAssertEqual(response.fakeRequest!.responseType, .data)
            XCTAssertEqual(response.fakeRequest!.queryDic!, ["queryKey": "queryValue"])
            XCTAssertEqual(response.fakeRequest!.params!["paramKey"] as! String, "paramValue")
        }
    }
    
    func testCreateHttpRequest() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath) as! FakeRequest

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
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, requestType: .upload, queryDic: ["fake": "queryDic"], params: ["fake": "paramDic"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        XCTAssertEqual(fakeRequest.requestType, .upload)
        XCTAssertEqual(fakeRequest.queryDic!, ["fake": "queryDic"])
        XCTAssertEqual(fakeRequest.params as! Dictionary, ["fake": "paramDic"])
    }
    
    func testCreateHttpRequestWithHttpMethodAndResponseType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, responseType: .data, queryDic: ["fake": "queryDic"], params: ["fake": "paramDic"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        XCTAssertEqual(fakeRequest.responseType, .data)
        XCTAssertEqual(fakeRequest.queryDic!, ["fake": "queryDic"])
        XCTAssertEqual(fakeRequest.params as! Dictionary, ["fake": "paramDic"])
    }
    
    func testCreateHttpRequestWithRequestTypeAndResponseType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, requestType: .upload, responseType: .data, queryDic: ["fake": "queryDic"], params: ["fake": "paramDic"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.requestType, .upload)
        XCTAssertEqual(fakeRequest.responseType, .data)
        XCTAssertEqual(fakeRequest.queryDic!, ["fake": "queryDic"])
        XCTAssertEqual(fakeRequest.params as! Dictionary, ["fake": "paramDic"])
    }
    
    func testCreateHttpRequestWithHttpMethodAndRequestTypeAndResponseType() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, requestType: .upload, responseType: .data, queryDic: ["fake": "queryDic"], params: ["fake": "paramDic"]) as! FakeRequest
        
        XCTAssertEqual(fakeRequest.httpMethod, .post)
        XCTAssertEqual(fakeRequest.requestType, .upload)
        XCTAssertEqual(fakeRequest.responseType, .data)
        XCTAssertEqual(fakeRequest.queryDic!, ["fake": "queryDic"])
        XCTAssertEqual(fakeRequest.params as! Dictionary, ["fake": "paramDic"])
    }
    
    func testGoRequest() {
        let fakeRequest = aintx.createHttpRequest(path: fakePath, method: .post, requestType: .upload, responseType: .data, queryDic: ["queryKey": "queryValue"], params: ["paramKey": "paramValue"])
        
        aintx.go(fakeRequest) { (response) in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.httpMethod, .post)
            XCTAssertEqual(response.fakeRequest!.requestType, .upload)
            XCTAssertEqual(response.fakeRequest!.responseType, .data)
            XCTAssertEqual(response.fakeRequest!.queryDic!, ["queryKey": "queryValue"])
            XCTAssertEqual(response.fakeRequest!.params!["paramKey"] as! String, "paramValue")
        }
    }
    
}
