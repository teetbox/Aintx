//
//  AintxInternalTests.swift
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

class AintxInternalTests: XCTestCase {
    
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
        XCTAssertEqual(aintx.session, URLSession.shared)
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
        
        let token = aintx.get(fakePath) { _ in }
        XCTAssertNotNil(token.sessionTask)
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .get)
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.put(fakePath) { _ in }
        XCTAssertNotNil(token.sessionTask)
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .put)
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.post(fakePath) { _ in }
        XCTAssertNotNil(token.sessionTask)
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .post)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        let token = aintx.delete(fakePath) { _ in }
        XCTAssertNotNil(token.sessionTask)
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
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
        
        request = aintx.dataRequest(path: fakePath, params: ["key": "value"], method: .put) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.method, .put)
        
        request = aintx.dataRequest(path: fakePath, params: ["key": "value"], method: .delete) as! FakeRequest
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.method, .delete)
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
    
    func testUploadRequest() {
        let fileData: UploadType = .data(Data())
        var request = aintx.uploadRequest(path: fakePath, uploadType: fileData, params: nil, method: .put)
        
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .put)
        XCTAssertNil(request.params)
        XCTAssertEqual((request as! FakeRequest).uploadType, fileData)
        
        let fileURL: UploadType = .url(URL(string: "file/path")!)
        request = aintx.uploadRequest(path: fakePath, uploadType: fileURL, params: nil, method: .put)
        
        XCTAssertEqual((request as! FakeRequest).uploadType, fileURL)
    }
    
    func testDownload() {
        
    }
    
}
