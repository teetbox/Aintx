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
        let fileURL = URL(string: "/Users/matt/Desktop/swift.jpeg")!
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        sut.upload(path, fileURL: fileURL, params: nil, headers: headers) { response in
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
        
        sut.upload(path, fileData: imageData, params: params) { response in
            let urlResponse = response.urlResponse as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            XCTAssertEqual(statusCode, 200)
            let json = response.json as? [String: Any]
            print(json)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 50)
    }
    
    func testFileRequestForUpload() {
        let path = "https://efbplus.ceair.com:600/hwappcms/etp/fileUpload/uploadIcon"
        let params = ["userNo": "test1234"]
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        sut.fileRequest(uploadPath: path, uploadType: .data(imageData), method: .post, params: params) { url, error in
            self.async.fulfill()
        }.go()
        
        wait(for: [async], timeout: 50)
    }
    
}
