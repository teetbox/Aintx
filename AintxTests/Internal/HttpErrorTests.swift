//
//  HttpErrorTests.swift
//  AintxTests
//
//  Created by Tong Tian on 08/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpErrorTests: XCTestCase {
    
    var sut: HttpError!

    func testRequestError() {
        sut = HttpError.requestError(.paramsAndBodyDataUsedTogether("POST"))
        XCTAssertEqual(sut.localizedDescription, "Params and bodyData should not be used together in POST request")
        
        sut = HttpError.requestError(.dataRequestInBackgroundSession)
        XCTAssertEqual(sut.localizedDescription, "Data request can't run in background session")
        
        sut = HttpError.requestError(.emptyURLRequest)
        XCTAssertEqual(sut.localizedDescription, "URLRequest is nil")
    }
    
    func testEncodingError() {
        sut = HttpError.encodingError(.invalidURL("~!@#$"))
        XCTAssertEqual(sut.localizedDescription, "Invalid url: ~!@#$")
        
        sut = HttpError.encodingError(.invalidParams(["key": "value"]))
        XCTAssertEqual(sut.localizedDescription, "Invalid params: [\"key\": \"value\"]")
    }
    
    func testStatusCodeError() {
        sut = HttpError.statusError(HttpStatus(code: 400))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: \(400) - Bad Request")
        
        sut = HttpError.statusError(HttpStatus(code: 500))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: \(500) - Internal Server Error")
        
        sut = HttpError.statusError(HttpStatus(code: 999))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: 0 - Unknown")
        
        sut = HttpError.statusError(HttpStatus(code: 0))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: 0 - Unknown")
    }
    
    func testResponseError() {
        let error = NSError(domain: "response", code: 0)
        sut = HttpError.responseError(error)
        XCTAssertEqual(sut.localizedDescription, "The operation couldn’t be completed. (response error 0.)")
    }
    
}
