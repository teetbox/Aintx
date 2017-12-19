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
    
    var sut: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: fakeBase)
        sut.isFake = true
    }
    
    func testInit() {
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.config, .standard)
    }
    
    func testInitWithConfig() {
        sut = Aintx(base: fakeBase, config: .standard)
        XCTAssertEqual(sut.config, .standard)
        
        sut = Aintx(base: fakeBase, config: .ephemeral)
        XCTAssertEqual(sut.config, .ephemeral)
        
        sut = Aintx(base: fakePath, config: .background("background"))
        XCTAssertEqual(sut.config, .background("background"))
    }
    
    func testGet() {
        sut.get(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        sut.get(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
        
        sut.get(fakePath, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.get(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.isFake = false
        let httpTask = sut.get(fakePath) { _ in }
        XCTAssert(httpTask is HttpDataTask)
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDataTask)
    }
    
    func testPut() {
        sut.put(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        sut.put(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
        
        sut.put(fakePath, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.put(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.isFake = false
        let httpTask = sut.put(fakePath) { _ in }
        XCTAssert(httpTask is HttpDataTask)
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDataTask)
    }
    
    func testPost() {
        sut.post(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        sut.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
        
        let bodyData = "body".data(using: .utf8)
        sut.post(fakePath, bodyData: bodyData) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.bodyData, bodyData)
        }
        
        sut.post(fakePath, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.post(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.post(fakePath, bodyData: bodyData, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .post)
            XCTAssertEqual(response.fakeRequest!.bodyData, bodyData)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.isFake = false
        let httpTask = sut.post(fakePath) { _ in }
        XCTAssert(httpTask is HttpDataTask)
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDataTask)
    }
    
    func testDelete() {
        sut.delete(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertNil(response.fakeRequest!.params)
        }
        
        sut.delete(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
        
        sut.delete(fakePath, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.delete(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .delete)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.isFake = false
        let httpTask = sut.delete(fakePath) { _ in }
        XCTAssert(httpTask is HttpDataTask)
        
        let dataTask = httpTask as! HttpDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDataTask)
    }
    
    func testDataRequest() {
        let request = sut.dataRequest(path: fakePath)

        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .get)
        XCTAssertNil(request.params)
        XCTAssertNil(request.headers)
        XCTAssertNil(request.bodyData)
    }
    
    func testDataRequestWithMethod() {
        var request: HttpRequest
        
        request = sut.dataRequest(path: fakePath, method: .get)
        XCTAssertEqual(request.method, .get)
        
        request = sut.dataRequest(path: fakePath, method: .put)
        XCTAssertEqual(request.method, .put)
        
        request = sut.dataRequest(path: fakePath, method: .post)
        XCTAssertEqual(request.method, .post)
        
        request = sut.dataRequest(path: fakePath, method: .delete)
        XCTAssertEqual(request.method, .delete)
    }
    
    func testDataRequestWithParams() {
        let request = sut.dataRequest(path: fakePath, params: ["key": "value"])
        XCTAssertEqual(request.params!["key"] as! String, "value")
    }
    
    func testDataRequestWithHeaders() {
        let request = sut.dataRequest(path: fakePath, headers: ["key": "value"])
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
    func testDataRequestWithBodyData() {
        let bodyData = "body".data(using: .utf8)
        let request = sut.dataRequest(path: fakePath, bodyData: bodyData)
        XCTAssertEqual(request.bodyData, bodyData)
    }
    
    func testDataRequestWithAll() {
        let request  = sut.dataRequest(path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], bodyData: Data())

        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.headers!["key"], "value")
        XCTAssertEqual(request.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertEqual(request.bodyData, Data())
        XCTAssertEqual(request.taskType, .data)
        
        request.go { response in
            XCTAssertNotNil(response.fakeRequest)
            XCTAssertEqual(response.fakeRequest!.base, self.fakeBase)
            XCTAssertEqual(response.fakeRequest!.path, self.fakePath)
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
            XCTAssertEqual(response.fakeRequest!.bodyData, Data())
        }
    }
    
    func testDownload() {
        sut.download(fakePath) { response in
            XCTAssertEqual(response.fakeRequest!.path, "/fake/path")
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.taskType, .file(.download))
        }
        
        sut.download(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
        }
        
        sut.download(fakePath, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.download(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .get)
            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
        
        sut.isFake = false
        let downloadTask = sut.download(fakePath, completion: { _ in })
        XCTAssert(downloadTask is HttpDataTask)
        
        let dataTask = downloadTask as! HttpDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDownloadTask)
    }
    
    func testFileRequestForDownload() {
        var request: HttpFileRequest
        
        request = sut.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .get)
        XCTAssertNil(request.params)
        XCTAssertNil(request.headers)
        XCTAssertEqual(request.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertNil(request.progress)
        XCTAssertNotNil(request.completed)

        request = sut.fileRequest(downloadPath: fakePath, params: ["key": "value"], headers: ["key": "value"], progress: { _, _, _ in }, completed: { _, _ in })
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.headers!["key"], "value")
        XCTAssertEqual(request.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertNotNil(request.progress)
        XCTAssertNotNil(request.completed)
    }
    
    func testFileRequestForUpload() {
        // TODO: - A private function for both downloadRequest and uploadRequest using
    }
    
    // TODO: -
    
    func _testUploadWithFileURL() {
        let fileURL = URL(string: "/file/path")!
        sut.upload(fakePath, fileURL: fileURL) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
//            XCTAssertEqual(response.fakeRequest!.uploadType, UploadType.url(fileURL))
        }
    }
    
    func _testUploadWithData() {
        let fileData = Data()
        sut.upload(fakePath, fileData: fileData) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
//            XCTAssertEqual(response.fakeRequest!.uploadType, UploadType.data(fileData))
        }
    }
    
    func _testUploadWithHeaders() {
        let fileData = Data()
        sut.upload(fakePath, fileData: fileData, headers: ["key": "value"]) { response in
            XCTAssertEqual(response.fakeRequest!.method, .put)
//            XCTAssertEqual(response.fakeRequest!.uploadType, UploadType.data(fileData))
            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
        }
    }
    
    func _testUploadRequest() {
        let fileData: UploadType = .data(Data())
        var request = sut.uploadRequest(path: fakePath, method: .put, uploadType: fileData, params: nil)
        
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.method, .put)
        XCTAssertNil(request.params)
        XCTAssertEqual(request.uploadType, fileData)
        
        let fileURL: UploadType = .url(URL(string: "/file/path")!)
        request = sut.uploadRequest(path: fakePath, method: .put, uploadType: fileURL, params: nil)
        XCTAssertEqual(request.uploadType, fileURL)
    }
    
    func _testUploadRequestWithHeaders() {
        let fileURL: UploadType = .url(URL(string: "/file/path")!)
        let request = sut.uploadRequest(path: fakePath, method: .put, uploadType: fileURL, headers: ["key": "value"])
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
    func _testUploadRequestWithParamsAndHeaders() {
        let fileURL: UploadType = .url(URL(string: "/file/path")!)
        let request = sut.uploadRequest(path: fakePath, method: .put, uploadType: fileURL, params: ["key": "value"], headers: ["key": "value"])
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.headers!["key"], "value")
    }

    
//    func testDownloadWithParams() {
//        sut.download(fakePath, params: ["key": "value"]) { response in
//            XCTAssertEqual(response.fakeRequest!.method, .get)
//            XCTAssertEqual(response.fakeRequest!.params!["key"] as! String, "value")
//        }
//    }
//
//    func testDownloadWithHeaders() {
//        sut.download(fakePath, headers: ["key": "value"]) { response in
//            XCTAssertEqual(response.fakeRequest!.method, .get)
//            XCTAssertEqual(response.fakeRequest!.headers!["key"], "value")
//        }
//    }
    
    func testDownloadRequestWithParams() {
        let request = sut.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], completed: { _, _ in })
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.params!["key"] as! String, "value")
    }
    
    func testDownloadRequestWithParamsAndHeaders() {
        let request = sut.downloadRequest(path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], completed: { _, _ in })
        XCTAssertEqual(request.base, fakeBase)
        XCTAssertEqual(request.path, fakePath)
        XCTAssertEqual(request.params!["key"] as! String, "value")
        XCTAssertEqual(request.headers!["key"], "value")
    }
    
}
