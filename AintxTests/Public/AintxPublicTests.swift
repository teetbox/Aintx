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
    
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }

    func testGet() {
        aintx.get(fakePath) { response in
            XCTAssertNotNil(response)
        }

        aintx.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }

        aintx.get(fakePath, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.get(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        let task = aintx.get(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }

        aintx.put(fakePath, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.put(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        let task = aintx.put(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }

        aintx.post(fakePath, bodyData: Data()) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.post(fakePath, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.post(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.post(fakePath, bodyData: Data(), headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        let task = aintx.post(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertNotNil(response)
        }

        aintx.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.delete(fakePath, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.delete(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        let task = aintx.delete(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testDataRequest() {
        var request = aintx.dataRequest(path: fakePath)
        XCTAssertNotNil(request)
    
        request = aintx.dataRequest(path: fakePath, params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.dataRequest(path: fakePath, headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.dataRequest(path: fakePath, headers: ["key": "value"], bodyData: Data())
        XCTAssertNotNil(request)
    
        request = aintx.dataRequest(path: fakePath, method: .put, params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
    
        request = aintx.dataRequest(path: fakePath, method: .post, params: ["key": "value"], headers: ["key": "value"], bodyData: Data())
        XCTAssertNotNil(request)
    }

    func testUploadWithURL() {
        let fileURL = URL(string: "/file/path")!
        aintx.upload(fakePath, fileURL: fileURL) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.upload(fakePath, fileURL: fileURL, params: nil) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.upload(fakePath, fileURL: fileURL, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.upload(fakePath, fileURL: fileURL, params: nil, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    
        aintx.upload(fakePath, fileData: Data()) { response in
            XCTAssertNotNil(response)
        }
    
        aintx.upload(fakePath, fileData: Data(), params: nil) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.upload(fakePath, fileData: Data(), headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.upload(fakePath, fileData: Data(), params: nil, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadRequest() {
        var request = aintx.uploadRequest(path: fakePath, uploadType: .data(Data()))
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()))
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()), params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()), headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .data(Data()), params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .url(URL(string: "/file/path")!))
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .url(URL(string: "/file/path")!), params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .url(URL(string: "/file/path")!), headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: .url(URL(string: "/file/path")!), params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
    }
    
    func testDownload() {
        aintx.download(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.download(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.download(fakePath, headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
        
        aintx.download(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testDownLoadWithProgress() {
        let progress: ProgressClosure = { (_, writtenBytes, totalBytes) in
            let percentage = writtenBytes / totalBytes * 100
            print("Downloading \(percentage)%")
        }
        
        let completed: CompletedClosure = { _, _ in }
        
        let request = aintx.downloadRequest(path: fakePath, progress: progress, completed: completed)
        
        XCTAssertNotNil(request)
    }
    
    func testDownloadRequest() {
        var request = aintx.downloadRequest(path: fakePath, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = aintx.downloadRequest(path: fakePath, method: .get, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = aintx.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = aintx.downloadRequest(path: fakePath, method: .get, headers: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = aintx.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
    }
    
    func testFakeDataResponse() {
        let fakeData = "data".data(using: .utf8)
        aintx.fakeResponse = HttpResponse(data: fakeData)
        
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        aintx.upload(fakePath, fileData: fakeData!) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        aintx.upload(fakePath, fileURL: URL(string: "/file/path")!) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        aintx.download(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
    }
    
}
