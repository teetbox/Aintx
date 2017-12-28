//
//  UploadTests.swift
//  AintxTests
//
//  Created by Matt Tian on 22/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class UploadTests: XCTestCase {
    
    var sut: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: "")
        async = expectation(description: "async")
    }
    
    func testUpload() {
        let path = "http://127.0.0.1:8000/upload"
//        let fileURL = URL(string: "/Users/matt/Desktop/swift.jpeg")!
        let content = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: Data())
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        sut.upload(path, contents: content, params: nil, headers: headers) { response in
            let httpResponse = response.urlResponse as? HTTPURLResponse
            let code = httpResponse?.statusCode
            
            XCTAssertNil(response.error)
            XCTAssertEqual(code, 200)
            let dataString = String(data: response.data ?? Data(), encoding: .utf8)
            print("Data: \(dataString ?? "is blank")")

            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 20)
    }
    
    func testUploadProfileFromData() {
        let path = "https://efbplus.ceair.com:600/hwappcms/etp/fileUpload/uploadIcon"
        let params = ["userNo": "test1234"]
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        let content = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: imageData)
        
        sut.upload(path, contents: content, params: params) { response in
            let urlResponse = response.urlResponse as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            XCTAssertEqual(statusCode, 200)
            let json = response.json as? [String: Any]
            print(json)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 50)
    }
    
    func testFileRequestByBodyData() {
        let path = "https://efbplus.ceair.com:600/hwappcms/etp/fileUpload/uploadIcon"
        let params = ["userNo": "test1234"]
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        let content = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: imageData)
        
        let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Uploading file \(String(format: "%.2f", percentage))%")
        }
        
        sut.fileRequest(uploadPath: path, method: .post, contents: content, params: params, progress: progress) { url, error in
            print(url)
            print(error?.localizedDescription)
            self.async.fulfill()
        }.go()
        
        wait(for: [async], timeout: 50)
    }
    
}
