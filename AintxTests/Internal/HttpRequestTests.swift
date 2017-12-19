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

extension GroupType: Equatable {
    public static func ==(lhs: GroupType, rhs: GroupType) -> Bool {
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
    
    func testGoForDataRequest() {
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .ephemeral, bodyData: nil)
        
        (sut as! HttpDataRequest).go(completion: { _ in })
        let httpTask = (sut as! HttpDataRequest).go(completion: { _ in })
        XCTAssert(httpTask is HttpDataTask)        
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
    
    func testFileRequest() {
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, taskType: .file(.download), progress: progress, completed: completed)
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertNotNil(sut.urlString)
        XCTAssertNotNil(sut.urlRequest)
        XCTAssertEqual((sut as! HttpFileRequest).taskType, .file(.download))
        XCTAssertNotNil((sut as! HttpFileRequest).progress)
        XCTAssertNotNil((sut as! HttpFileRequest).completed)
        XCTAssertEqual((sut as! HttpFileRequest).sessionManager, SessionManager.shared)
    }
    
    func testGoForFileRequest() {
        sut = HttpFileRequest(base: fakeBase, path: fakePath, method:.get, params: nil, headers: nil, sessionConfig: .background("bg"), taskType: .file(.download), completed: nil)
        
        (sut as! HttpFileRequest).go()
        let task = (sut as! HttpFileRequest).go()
        XCTAssert(task is HttpFileTask)
        
        let sessionManager = SessionManager.shared
        let fileTask = task as! HttpFileTask
        XCTAssertNotNil(sessionManager[fileTask.sessionTask])
    }
    
    func testRequestGroup() {
        let fileRequest = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .file(.download), completed: nil)
        let fileRequest2 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .file(.download), completed: nil)
        let fileRequest3 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .file(.download), completed: nil)
        
        let group = HttpRequestGroup(lhs: fileRequest, rhs: fileRequest2, type: .sequential)
        XCTAssertFalse(group.isEmpty)
        XCTAssertEqual(group.type, .sequential)
        
        _ = group.append(fileRequest3)
        XCTAssertFalse(group.isEmpty)
        
        let tasks = group.go()
        XCTAssertEqual(tasks.count, 3)
    }
    
    // TODO: -
    
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
