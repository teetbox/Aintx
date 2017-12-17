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
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .standard))
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
    
    func testFakeDataRequest() {
        sut = FakeDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, bodyData: Data(), taskType: .data)
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertEqual((sut as! HttpDataRequest).bodyData, Data())
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .data)
    }
    
    func testGoForDataRequest() {
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .ephemeral, bodyData: nil)
        
        let httpTask = (sut as! HttpDataRequest).go(completion: { _ in })
        XCTAssertNotNil(httpTask)
    }
    
    // TODO: -
    
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
