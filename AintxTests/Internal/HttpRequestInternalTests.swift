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
    
    func testInitFakeRequest() {
        let fakeRequest = httpRequest as! FakeRequest
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .get)
    }
    
    func testInitDataRequest() {
        let dataRequest = DataRequest(base: fakeBase, path: fakePath, params: ["key": "value"], method: .get, session: URLSession.shared)
        
        XCTAssertEqual(dataRequest.base, fakeBase)
        XCTAssertEqual(dataRequest.path, fakePath)
        XCTAssertEqual(dataRequest.params!["key"] as! String, "value")
        XCTAssertEqual(dataRequest.method, .get)
    }
    
    func testInitDownloadRequest() {
        let downloadRequest = DownloadRequest(base: fakeBase, path: fakePath, params: ["key": "value"], method: .get, session: URLSession.shared)
        
        XCTAssertEqual(downloadRequest.base, fakeBase)
        XCTAssertEqual(downloadRequest.path, fakePath)
        XCTAssertEqual(downloadRequest.params!["key"] as! String, "value")
        XCTAssertEqual(downloadRequest.method, .get)
    }
    
    func testInitUploadRequest() {
        var uploadType: UploadType = .data(Data())
        
        var uploadRequest = UploadRequest(base: fakeBase, path: fakePath, uploadType: uploadType, params: ["key": "value"], method: .put, session: URLSession.shared)
        
        XCTAssertEqual(uploadRequest.base, fakeBase)
        XCTAssertEqual(uploadRequest.path, fakePath)
        XCTAssertEqual(uploadRequest.uploadType, .data(Data()))
        XCTAssertEqual(uploadRequest.params!["key"] as! String, "value")
        XCTAssertEqual(uploadRequest.method, .put)
        
        uploadType = .url(URL(string: "file/path")!)
        
        uploadRequest = UploadRequest(base: fakeBase, path: fakePath, uploadType: uploadType, params: ["key": "value"], method: .post, session: URLSession.shared)
        
        XCTAssertEqual(uploadRequest.base, fakeBase)
        XCTAssertEqual(uploadRequest.path, fakePath)
        XCTAssertEqual(uploadRequest.uploadType, .url(URL(string: "file/path")!))
        XCTAssertEqual(uploadRequest.params!["key"] as! String, "value")
        XCTAssertEqual(uploadRequest.method, .post)
    }
    
    func testInitFakeUploadRequest() {
        var uploadType: UploadType = .data(Data())
        
        var fakeRequest = FakeRequest(base: fakeBase, path: fakePath, params: ["key": "value"], method: .put, uploadType: uploadType, session: URLSession.shared)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.uploadType, .data(Data()))
        XCTAssertEqual(fakeRequest.params!["key"] as! String, "value")
        XCTAssertEqual(fakeRequest.method, .put)
        
        uploadType = .url(URL(string: "file/path")!)
        
        fakeRequest = FakeRequest(base: fakeBase, path: fakePath, params: ["key": "value"], method: .put, uploadType: uploadType, session: URLSession.shared)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.uploadType, .url(URL(string: "file/path")!))
        XCTAssertEqual(fakeRequest.params!["key"] as! String, "value")
        XCTAssertEqual(fakeRequest.method, .put)
    }
    
    func testInitStreamRequest() {
        let streamRequest = StreamRequest(base: fakeBase, path: fakePath, params: ["key": "value"], method: .get, session: URLSession.shared)
        
        XCTAssertEqual(streamRequest.base, fakeBase)
        XCTAssertEqual(streamRequest.path, fakePath)
        XCTAssertEqual(streamRequest.params!["key"] as! String, "value")
        XCTAssertEqual(streamRequest.method, .get)
    }
    
    func testGo() {
        httpRequest.go { response in
            XCTAssertNotNil(response.fakeRequest)
        }
        
        let token = httpRequest.go { _ in }
        XCTAssertNotNil(token.sessionTask)
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
