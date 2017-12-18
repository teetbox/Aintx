//
//  AintxPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class AintxPublicTests: XCTestCase {
    
    var sut: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: fakeBase)
    }

    func testGet() {
        sut.get(fakePath) { response in }
        sut.get(fakePath, params: ["key": "value"]) { response in }
        sut.get(fakePath, headers: ["key": "value"]) { response in }
        sut.get(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.get(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testPut() {
        sut.put(fakePath) { response in }
        sut.put(fakePath, params: ["key": "value"]) { response in }
        sut.put(fakePath, headers: ["key": "value"]) { response in }
        sut.put(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.put(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testPost() {
        sut.post(fakePath) { response in }
        sut.post(fakePath, params: ["key": "value"]) { response in }
        sut.post(fakePath, bodyData: Data()) { response in }
        sut.post(fakePath, headers: ["key": "value"]) { response in }
        sut.post(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        sut.post(fakePath, bodyData: Data(), headers: ["key": "value"]) { response in }
        
        let task = sut.post(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testDelete() {
        sut.delete(fakePath) { response in }
        sut.delete(fakePath, params: ["key": "value"]) { response in }
        sut.delete(fakePath, headers: ["key": "value"]) { response in }
        sut.delete(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.delete(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testDataRequest() {
        var request = sut.dataRequest(path: fakePath)
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, method: .post)
        XCTAssertNotNil(request)
    
        request = sut.dataRequest(path: fakePath, params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, headers: ["key": "value"], bodyData: Data())
        XCTAssertNotNil(request)
    
        request = sut.dataRequest(path: fakePath, method: .put, params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request.go(completion: { _ in })
    }
    
    func testDownload() {
        sut.download(fakePath) { response in }
        sut.download(fakePath, params: ["key": "value"]) { response in }
        sut.download(fakePath, headers: ["key": "value"]) { response in }
        sut.download(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let request = sut.download(fakePath, completion: { _ in })
        XCTAssertNotNil(request)
    }
    
    func testDownloadRequest() {
        var request = sut.downloadRequest(path: fakePath, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.downloadRequest(path: fakePath, method: .get, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.downloadRequest(path: fakePath, params: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.downloadRequest(path: fakePath, headers: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.downloadRequest(path: fakePath, progress:{ _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], progress: { _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request.go()
    }
    
    func testFileRequestGroup() {
//        let fileRequest = sut.downloadRequest(path: fakePath, completed: { _, _ in })
//        let fileRequest2 = sut.downloadRequest(path: fakePath, completed: { _, _ in })
//        let fileRequest3 = sut.downloadRequest(path: fakePath, completed: { _, _ in })
//        
//        let group = fileRequest.combine(fileRequest2)
    }
    
    // TODO: -
    func _testUpload() {
        let fileURL = URL(string: "/file/path")!
        sut.upload(fakePath, fileURL: fileURL) { response in
            XCTAssertNotNil(response)
        }
        
        sut.upload(fakePath, fileURL: fileURL, params: nil) { response in
            XCTAssertNotNil(response)
        }
        
        sut.upload(fakePath, fileURL: fileURL, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        sut.upload(fakePath, fileURL: fileURL, params: nil, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    
        sut.upload(fakePath, fileData: Data()) { response in
            XCTAssertNotNil(response)
        }
    
        sut.upload(fakePath, fileData: Data(), params: nil) { response in
            XCTAssertNotNil(response)
        }
        
        sut.upload(fakePath, fileData: Data(), headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        sut.upload(fakePath, fileData: Data(), params: nil, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func _testUploadRequest() {
        var request = sut.uploadRequest(path: fakePath, uploadType: .data(Data()))
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()))
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()), params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()), headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()), params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        let fileURL = URL(string: "/file/path")!
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .url(fileURL))
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .url(fileURL), params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .url(fileURL), headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: .url(fileURL), params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
    }
    
    func testFakeResponse() {
        let fakeData = "data".data(using: .utf8)
        sut.fakeResponse = HttpResponse(data: fakeData)
        
        sut.get(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.put(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.post(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.post(fakePath, bodyData: fakeData) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.delete(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.upload(fakePath, fileData: fakeData!) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.upload(fakePath, fileURL: URL(string: "/file/path")!) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.download(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
    }
    
}
