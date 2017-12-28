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
        let content = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: Data())
        let content2 = content
        let content3 = content
        
        sut.upload(fakePath, contents: content, completion: { _ in })
        sut.upload(fakePath, contents: content, content2, content3, completion: { _ in })
        
        let task = sut.upload(fakePath, contents: content, params: ["key": "value"], headers: ["key": "value"], completion: { _ in })
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
        let content = MultipartContent(name: "", fileName: "", contentType: .png, data: Data())
        var request = sut.fileRequest(uploadPath: fakePath, contents: content, progress:{ _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(uploadPath: fakePath, method: .post, contents: content, params: ["key": "value"], headers: ["key": "value"], progress: nil, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        let task = request.go()
        XCTAssertNotNil(task)
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
        
        sut.download(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        let content = MultipartContent(name: "", fileName: "", contentType: .png, data: Data())
        sut.upload(fakePath, contents: content) { response in
            XCTAssertEqual(response.data, fakeData)
        }
    }
    
}
