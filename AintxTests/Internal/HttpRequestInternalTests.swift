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
    
    var httpRequest: HttpRequest!
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
        httpRequest = aintx.dataRequest(path: fakePath)
    }
    
    func testInitDataRequest() {
        let dataRequest = DataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], bodyData: Data(), sessionConfig: .standard)
        
        XCTAssertEqual(dataRequest.base, fakeBase)
        XCTAssertEqual(dataRequest.path, fakePath)
        XCTAssertEqual(dataRequest.method, .get)
        XCTAssertEqual(dataRequest.params!["key"] as! String, "value")
        XCTAssertEqual(dataRequest.bodyData, Data())
    }
    
    func testInitDownloadRequest() {
        let progress: ProgressHandler = { _, _, _ in }
        let completion: CompletionHandler = { }
        
        let downloadRequest = DownloadRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], progress: progress, completion: completion, sessionConfig: .standard)
        
        XCTAssertEqual(downloadRequest.base, fakeBase)
        XCTAssertEqual(downloadRequest.path, fakePath)
        XCTAssertEqual(downloadRequest.method, .get)
        XCTAssertEqual(downloadRequest.params!["key"] as! String, "value")
        XCTAssertNotNil(downloadRequest.progress)
        XCTAssertNotNil(downloadRequest.completion)
    }
    
    func testInitUploadRequest() {
        var uploadType: UploadType = .data(Data())
        
        var uploadRequest = UploadRequest(base: fakeBase, path: fakePath, method: .put, uploadType: uploadType, params: ["key": "value"], sessionConfig: .standard)
        
        XCTAssertEqual(uploadRequest.base, fakeBase)
        XCTAssertEqual(uploadRequest.path, fakePath)
        XCTAssertEqual(uploadRequest.method, .put)
        XCTAssertEqual(uploadRequest.uploadType, .data(Data()))
        XCTAssertEqual(uploadRequest.params!["key"] as! String, "value")
        
        uploadType = .url(URL(string: "/file/path")!)
        
        uploadRequest = UploadRequest(base: fakeBase, path: fakePath, method: .post, uploadType: uploadType, params: ["key": "value"], sessionConfig: .standard)
        
        XCTAssertEqual(uploadRequest.base, fakeBase)
        XCTAssertEqual(uploadRequest.path, fakePath)
        XCTAssertEqual(uploadRequest.method, .post)
        XCTAssertEqual(uploadRequest.uploadType, .url(URL(string: "/file/path")!))
        XCTAssertEqual(uploadRequest.params!["key"] as! String, "value")
    }

    func testInitFakeRequest() {
        let fakeRequest = httpRequest as! FakeRequest
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .get)
    }
    
    func testInitFakePostRequest() {
        let bodyData = "body".data(using: .utf8)
        let fakeRequest = FakeRequest(base: fakeBase, path: fakePath, method: .post, bodyData: bodyData, sessionConfig: .standard)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .post)
        XCTAssertEqual(fakeRequest.bodyData, bodyData)
    }
    
    func testInitFakeUploadRequest() {
        var uploadType: UploadType = .data(Data())
        
        var fakeRequest = FakeRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], uploadType: uploadType, sessionConfig: .standard)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .put)
        XCTAssertEqual(fakeRequest.uploadType, .data(Data()))
        XCTAssertEqual(fakeRequest.params!["key"] as! String, "value")
        
        uploadType = .url(URL(string: "/file/path")!)
        
        fakeRequest = FakeRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], uploadType: uploadType, sessionConfig: .standard)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .put)
        XCTAssertEqual(fakeRequest.uploadType, .url(URL(string: "/file/path")!))
        XCTAssertEqual(fakeRequest.params!["key"] as! String, "value")
    }
    
    func testInitStreamRequest() {
        let streamRequest = StreamRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], sessionConfig: .standard)
        
        XCTAssertEqual(streamRequest.base, fakeBase)
        XCTAssertEqual(streamRequest.path, fakePath)
        XCTAssertEqual(streamRequest.method, .get)
        XCTAssertEqual(streamRequest.params!["key"] as! String, "value")
    }
    
    func testGo() {
        httpRequest.go { response in
            XCTAssertNotNil(response.fakeRequest)
        }
        
        let httpTask = httpRequest.go { _ in }
        XCTAssertNotNil(httpTask)
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
