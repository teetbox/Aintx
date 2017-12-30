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
    
    override func setUp() {
        super.setUp()
    }
    
    func testInvalidURL() {
        sut = HttpError.encodingFailed(.invalidURL("~!@#$"))
        XCTAssertEqual(sut.localizedDescription, "Invalid url: ~!@#$")
    }
    
    func testUnsupportedSession() {
        sut = HttpError.requestFailed(.dataRequestInBackgroundSession)
        XCTAssertEqual(sut.localizedDescription, "Data request can't run in background session")
    }
    
    func testParamsAndBodyDataUsedTogether() {
        sut = HttpError.requestFailed(.paramsAndBodyDataUsedTogether)
        XCTAssertEqual(sut.localizedDescription, "Params and bodyData should not be used together in dataRequest")
    }
    
    func testStatusCodeError() {
        sut = HttpError.statusCodeError(HttpStatus(code: 400))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: \(400) - Bad Request")
        
        sut = HttpError.statusCodeError(HttpStatus(code: 500))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: \(500) - Internal Server Error")
        
        sut = HttpError.statusCodeError(HttpStatus(code: 999))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: 0 - Unknown")
        
        sut = HttpError.statusCodeError(HttpStatus(code: 0))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: 0 - Unknown")
    }
    
}
