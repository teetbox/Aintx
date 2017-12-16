//
//  HttpRequestTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

extension TaskType: Equatable {
    public static func ==(lhs: TaskType, rhs: TaskType) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

class HttpRequestTests: XCTestCase {
    
    var sut: HttpRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        sut = HttpRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard)
    }
    
    func testInit() {
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .put)
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertNotNil(sut.urlString)
        XCTAssertNotNil(sut.urlRequest)
    }
    
    func testDataRequest() {
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, bodyData: Data(), taskType: .data)
        XCTAssertEqual((sut as! HttpDataRequest).bodyData, Data())
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .data)
        
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .file(.download))
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .file(.download))
        
        let fileURL = URL(string: "www.fake.com")!
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .file(.upload(.url(fileURL))))
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .file(.upload(.url(fileURL))))
        
        let fileData = "data".data(using: .utf8)!
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .file(.upload(.data(fileData))))
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .file(.upload(.data(fileData))))
    }
    
    func testDownloadRequest() {
        let progress: ProgressClosure = { _, _, _ in }
        let completion: (HttpResponse) -> Void = { _ in }
        
        let downloadRequest = HttpDownloadRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: nil, sessionConfig: .standard, progress: progress, completion: completion)
        XCTAssertEqual(downloadRequest.base, fakeBase)
        XCTAssertEqual(downloadRequest.path, fakePath)
        XCTAssertEqual(downloadRequest.method, .get)
        XCTAssertEqual(downloadRequest.params!["key"] as! String, "value")
    }
    
    func testInitUploadRequest() {
        var uploadType: UploadType = .data(Data())
        
        var uploadRequest = HttpUploadRequest(base: fakeBase, path: fakePath, method: .put, uploadType: uploadType, params: ["key": "value"], sessionConfig: .standard)
        
        XCTAssertEqual(uploadRequest.base, fakeBase)
        XCTAssertEqual(uploadRequest.path, fakePath)
        XCTAssertEqual(uploadRequest.method, .put)
        XCTAssertEqual(uploadRequest.uploadType, .data(Data()))
        XCTAssertEqual(uploadRequest.params!["key"] as! String, "value")
        
        uploadType = .url(URL(string: "/file/path")!)
        
        uploadRequest = HttpUploadRequest(base: fakeBase, path: fakePath, method: .post, uploadType: uploadType, params: ["key": "value"], sessionConfig: .standard)
        
        XCTAssertEqual(uploadRequest.base, fakeBase)
        XCTAssertEqual(uploadRequest.path, fakePath)
        XCTAssertEqual(uploadRequest.method, .post)
        XCTAssertEqual(uploadRequest.uploadType, .url(URL(string: "/file/path")!))
        XCTAssertEqual(uploadRequest.params!["key"] as! String, "value")
    }

    func _testInitFakeRequest() {
        let fakeRequest = sut as! FakeHttpRequest
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .get)
    }
    
    func testInitFakePostRequest() {
        let bodyData = "body".data(using: .utf8)
        let fakeRequest = FakeHttpRequest(base: fakeBase, path: fakePath, method: .post, bodyData: bodyData, sessionConfig: .standard)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .post)
        XCTAssertEqual(fakeRequest.bodyData, bodyData)
    }
    
    func testInitFakeUploadRequest() {
        var uploadType: UploadType = .data(Data())
        
        var fakeRequest = FakeHttpRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], uploadType: uploadType, sessionConfig: .standard)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .put)
        XCTAssertEqual(fakeRequest.uploadType, .data(Data()))
        XCTAssertEqual(fakeRequest.params!["key"] as! String, "value")
        
        uploadType = .url(URL(string: "/file/path")!)
        
        fakeRequest = FakeHttpRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], uploadType: uploadType, sessionConfig: .standard)
        
        XCTAssertEqual(fakeRequest.base, fakeBase)
        XCTAssertEqual(fakeRequest.path, fakePath)
        XCTAssertEqual(fakeRequest.method, .put)
        XCTAssertEqual(fakeRequest.uploadType, .url(URL(string: "/file/path")!))
        XCTAssertEqual(fakeRequest.params!["key"] as! String, "value")
    }
    
    func testGo() {
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .ephemeral, bodyData: nil)
        
        (sut as! HttpDataRequest).go { response in
            
        }
        
        XCTAssert(sut is HttpDataRequest)
        
        let httpTask = (sut as! HttpDataRequest).go { _ in }
        XCTAssertNotNil(httpTask)
    }
    
    func _testSetAuthorizationWithUsernameAndPassword() {
        let loginString = "username:password"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        _ = sut.setAuthorization(username: "username", password: "password")
        
        XCTAssertEqual(sut.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
    }
    
    func _testSetAuthorizationWithBasicToken() {
        _ = sut.setAuthorization(basicToken: "ABC")
        
        XCTAssertEqual(sut.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic ABC")
    }
    
}
