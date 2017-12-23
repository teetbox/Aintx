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
    let fileURL = URL(string: "/Users/matt/Desktop/swift.jpg")!
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
    
}








