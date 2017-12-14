//
//  AintxTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/24/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

extension SessionConfig: Equatable {
    public static func ==(lhs: SessionConfig, rhs: SessionConfig) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

extension UploadType: Equatable {
    public static func ==(lhs: UploadType, rhs: UploadType) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

class AintxTests: XCTestCase {
    
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }
    
    func testInit() {
        XCTAssertEqual(aintx.base, fakeBase)
        XCTAssertEqual(aintx.config, .standard)
    }
    
    func testInitWithConfig() {
        aintx = Aintx(base: fakeBase, config: .ephemeral)
        XCTAssertEqual(aintx.config, .ephemeral)
        
        aintx = Aintx(base: fakePath, config: .background("bg"))
        XCTAssertEqual(aintx.config, .background("bg"))
    }
    
    func testGet() {
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let httpTask = aintx.get(fakePath) { _ in }
        XCTAssertNotNil(httpTask)
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testGetWithHeaders() {
        aintx.get(fakePath, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let httpTask = aintx.put(fakePath) { _ in }
        XCTAssertNotNil(httpTask)
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let httpTask = aintx.post(fakePath) { _ in }
        XCTAssertNotNil(httpTask)
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testPostWithBodyData() {
        let bodyData = "body".data(using: .utf8)
        aintx.post(fakePath, bodyData: bodyData) { response in
            XCTAssertEqual(response.fakeRequest!.bodyData, bodyData)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let httpTask = aintx.delete(fakePath) { _ in }
        XCTAssertNotNil(httpTask)
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
    }
    
    func testDataRequest() {
        let request = aintx.dataRequest(path: fakePath) as! FakeRequest
        
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .get)
        XCTAssertNil(request.params)
    }
    
    func testDataRequestWithParams() {
        let request = aintx.dataRequest(path: fakePath, params: ["key": "value"]) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
    }
    
    func testDataRequestWithBodyData() {
        let bodyData = "body".data(using: .utf8)
        let request = aintx.dataRequest(path: fakePath, method: .post, bodyData: bodyData) as! FakeRequest
        XCTAssertEqual(request.bodyData, bodyData)
    }
    
    func testDataRequestWithHeaders() {
        let request = aintx.dataRequest(path: fakePath, method: .post, headers: ["key": "value"])
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
    func testDataRequestWithMethod() {
        var request: FakeRequest
        
        request = aintx.dataRequest(path: fakePath, method: .put) as! FakeRequest
        XCTAssertEqual(request.method, .put)
        
        request = aintx.dataRequest(path: fakePath, method: .post) as! FakeRequest
        XCTAssertEqual(request.method, .post)
        
        request = aintx.dataRequest(path: fakePath, method: .delete) as! FakeRequest
        XCTAssertEqual(request.method, .delete)
    }
    
    func testDataRequestWithParamsAndMethod() {
        var request: FakeRequest
        
        request = aintx.dataRequest(path: fakePath, method: .put, params: ["key": "value"]) as! FakeRequest
        XCTAssertEqual(request.method, .put)
        XCTAssertEqual(request.params!["key"] as! String, "value")
        
        request = aintx.dataRequest(path: fakePath, method: .delete, params: ["key": "value"]) as! FakeRequest
        XCTAssertEqual(request.method, .delete)
        XCTAssertEqual(request.params!["key"] as! String, "value")
    }
    
    func testUploadWithFileURL() {
        let fileURL = URL(string: "/file/path")!
        aintx.upload(fakePath, fileURL: fileURL) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.uploadType, UploadType.url(fileURL))
        }
    }
    
    func testUploadWithData() {
        let fileData = Data()
        aintx.upload(fakePath, fileData: fileData) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.uploadType, UploadType.data(fileData))
        }
    }
    
    func testUploadWithHeaders() {
        let fileData = Data()
        aintx.upload(fakePath, fileData: fileData, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.uploadType, UploadType.data(fileData))
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
    }
    
    func testUploadRequest() {
        let fileData: UploadType = .data(Data())
        var request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: fileData, params: nil)
        
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .put)
        XCTAssertNil(request.params)
        XCTAssertEqual((request as! FakeRequest).uploadType, fileData)
        
        let fileURL: UploadType = .url(URL(string: "/file/path")!)
        request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: fileURL, params: nil)
        XCTAssertEqual((request as! FakeRequest).uploadType, fileURL)
    }
    
    func testUploadRequestWithHeaders() {
        let fileURL: UploadType = .url(URL(string: "/file/path")!)
        let request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: fileURL, headers: ["key": "value"])
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
    func testUploadRequestWithParamsAndHeaders() {
        let fileURL: UploadType = .url(URL(string: "/file/path")!)
        let request = aintx.uploadRequest(path: fakePath, method: .put, uploadType: fileURL, params: ["key": "value"], headers: ["key": "value"])
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
//    func testDownload() {
//        aintx.download(fakePath) { response in
//            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
//            XCTAssertEqual(response.fakeRequest!.method, .get)
//        }
//    }
    
//    func testDownloadWithParams() {
//        aintx.download(fakePath, params: ["key": "value"]) { response in
//            XCTAssertEqual(response.fakeRequest!.method, .get)
//            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
//        }
//    }
    
//    func testDownloadWithHeaders() {
//        aintx.download(fakePath, headers: ["key": "value"]) { response in
//            XCTAssertEqual(response.fakeRequest!.method, .get)
//            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
//        }
//    }
    
    func testDownloadRequest() {
        let request = aintx.downloadRequest(path: fakePath, method: .get, completed: { _, _ in })
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertNil(request.params)
    }
    
    func testDownloadRequestWithParams() {
        let request = aintx.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], completed: { _, _ in })
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.params!["key"] as! String, "value")
    }
    
    func testDownloadRequestWithParamsAndHeaders() {
        let request = aintx.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], completed: { _, _ in })
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
}
