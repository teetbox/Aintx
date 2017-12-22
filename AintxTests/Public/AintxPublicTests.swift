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
        
        let task = sut.download(fakePath, completion: { _ in })
        XCTAssertNotNil(task)
    }
    
    func testUpload() {
        let fileURL = URL(string: "/fake/url")!
        let fileData = "data".data(using: .utf8)!
        sut.upload(fakePath, fileURL: fileURL) { response in }
        sut.upload(fakePath, fileURL: fileURL, params: ["key": "value"]) { response in }
        sut.upload(fakePath, fileURL: fileURL, headers: ["key": "value"]) { response in }
        sut.upload(fakePath, fileURL: fileURL, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        sut.upload(fakePath, fileData: fileData) { response in }
        sut.upload(fakePath, fileData: fileData, params: ["key": "value"]) { response in }
        sut.upload(fakePath, fileData: fileData, headers: ["key": "value"]) { response in }
        sut.upload(fakePath, fileData: fileData, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        var task = sut.upload(fakePath, fileURL: fileURL, completion: { _ in })
        XCTAssertNotNil(task)
        
        task = sut.upload(fakePath, fileData: fileData, completion: { _ in })
        XCTAssertNotNil(task)
    }
    
    func testFileRequestForDownload() {
        var request = sut.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, method: .get, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, params: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, headers: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, progress:{ _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], progress: { _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        let task = request.go()
        XCTAssertNotNil(task)
    }
    
    func testFileRequestForUpload() {
        let fileURL = URL(string: "/fake/url")!
        let fileData = "data".data(using: .utf8)!
        
        var request = sut.fileRequest(uploadPath: fakePath, uploadType: .url(fileURL), progress:{ _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(uploadPath: fakePath, uploadType: .data(fileData), method: .post, params: ["key": "value"], headers: ["key": "value"], progress: nil, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        let task = request.go()
        XCTAssertNotNil(task)
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
