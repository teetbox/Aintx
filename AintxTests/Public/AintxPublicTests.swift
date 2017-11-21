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
        
        let token = aintx.get(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testGetWithParams() {
        aintx.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testPut() {
        aintx.put(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.put(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testPutWithParams() {
        aintx.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testPost() {
        aintx.post(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.post(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testPostWithParams() {
        aintx.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testDelete() {
        aintx.delete(fakePath) { response in
            XCTAssertNotNil(response)
        }
        
        let token = aintx.delete(fakePath) { _ in }
        XCTAssertNotNil(token)
    }
    
    func testDeleteWithParams() {
        aintx.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testDataRequest() {
        let request = aintx.dataRequest(path: fakePath)
        XCTAssertNotNil(request)
    }
    
    func testDataRequestWithParams() {
        let request = aintx.dataRequest(path: fakePath, params: ["key": "value"])
        XCTAssertNotNil(request)
    }
    
    func testDataRequestWithMethod() {
        let request = aintx.dataRequest(path: fakePath, method: .put)
        XCTAssertNotNil(request)
    }

    
    func testDataRequestWithParamsAndMethod() {
        let request = aintx.dataRequest(path: fakePath, params: ["key": "value"], method: .get)
        XCTAssertNotNil(request)
    }
    
    func testUploadWithURL() {
        let fileURL = URL(string: "/file/path")!
        aintx.upload(fakePath, fileURL: fileURL) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadWithURLAndParams() {
        let fileURL = URL(string: "/file/path")!
        aintx.upload(fakePath, fileURL: fileURL, params: nil) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadWithData() {
        aintx.upload(fakePath, fileData: Data()) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadWithDataAndParams() {
        aintx.upload(fakePath, fileData: Data(), params: nil) { response in
            XCTAssertNotNil(response)
        }
    }
    
    func testUploadRequest() {
        let request = aintx.uploadRequest(path: fakePath, type: .data(Data()), params: nil, method: .put)
        XCTAssertNotNil(request)
    }
    
    func testDownload() {
        aintx.download(fakePath) { response in
            XCTFail()
            XCTAssertNotNil(response)
        }
    }
    
    func testDownloadWithParams() {
        aintx.download(fakePath, params: nil) { response in
            XCTFail()
            XCTAssertNotNil(response)
        }
    }
    
    func testFakeResponse() {
        aintx.fakeResponse = HttpResponse(data: "data".data(using: .utf8))
        aintx.get(fakePath) { response in
            XCTAssertEqual(response.data, "data".data(using: .utf8))
        }
    }
    
    func testSaveToken() {
        aintx.saveToken("ABCDEFG")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "AINTX_SERVER_TOKEN"), "ABCDEFG")
        UserDefaults.standard.set(nil, forKey: "AINTX_SERVER_TOKEN")
    }
    
    func testRemoveToken() {
        aintx.saveToken("ABCDEFG")
        aintx.removeToken()
        XCTAssertNil(UserDefaults.standard.string(forKey: "AINTX_SERVER_TOKEN"))
    }
    
}
