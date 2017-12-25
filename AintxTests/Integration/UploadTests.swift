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
    
    let path = "http://127.0.0.1:8000/upload"
    let fileURL = URL(string: "/Users/matt/Desktop/swift.jpeg")!
    let headers = ["Content-Type": "application/x-www-form-urlencoded"]
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: "")
        async = expectation(description: "async")
    }
    
    func testUpload() {
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
    
    func testUploadProfile() {
        sut = Aintx(base: "https://efbplus.ceair.com:600/hwappcms/etp")
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        sut.post("/fileUpload/uploadIcon", bodyData: imageData) { response in
            let httpResponse = response.urlResponse as? HTTPURLResponse
            if let status = httpResponse?.statusCode {
                XCTAssertEqual(status, 200)
            }
            
            if let headers = httpResponse?.allHeaderFields {
                print(headers)
            }
            if let json = response.json {
                print(json)
            }
            if let error = response.error {
                print(error)
            }
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 50)
    }
    
    func testUpload2() {
        let headers = ["Content-Type": "multipart/form-data; boundary=--dfyguhimcbe"]
        sut = Aintx(base: "https://efbplus.ceair.com:600/hwappcms/etp")
        let request = sut.fileRequest(uploadPath: "/fileUpload/uploadIcon", uploadType: .url(URL(string: "/Users/matt/Desktop/swift.jpg")!), params: ["userNo": "go1234"], completed: { _, error in
            
            if let error = error {
                print(error)
            }
            
            self.async.fulfill()
        })
        
        request.go()
        wait(for: [async], timeout: 50)
    }
    
    func testImgurUpload() {
        let imgurBase = "https://api.imgur.com"
        let uploadPath = "/3/image"
        let clientID = "05dfe97d5d25788"
        
        sut = Aintx(base: imgurBase)
//        let request = sut.fileRequest(uploadPath: uploadPath, uploadType: .data(Data())) { url, error in
//            // TODO: - change url to data
//            print(error)
//            self.async.fulfill()
//        }
        //        request.go()

//        sut.upload(uploadPath, fileURL: fileURL, headers: ["Client-ID \(clientID)": "Authorization"]) { response in
//            let statusCode = (response.urlResponse as? HTTPURLResponse)?.statusCode
//            print(statusCode)
//            self.async.fulfill()
//        }
        
        let imageURL = "/Users/matt/Desktop/swift.jpeg";
        
        let imageData = try! Data(contentsOf: URL(string: imageURL)!)
        sut.post(uploadPath, bodyData: imageData, headers: ["Client-ID \(clientID)": "Authorization"]) { response in
            let statusCode = (response.urlResponse as? HTTPURLResponse)?.statusCode
            print(statusCode)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 50)
    }
    
}
