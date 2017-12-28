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
        sut = HttpError.requestFailed(.invalidURL("~!@#$"))
        XCTAssertEqual(sut.localizedDescription, "Invalid URL: ~!@#$")
    }
    
    func testUnsupportedSession() {
        sut = HttpError.requestFailed(.dataRequestInBackgroundSession)
        XCTAssertEqual(sut.localizedDescription, "Data request can't run in background session")
    }
    
    func testParamsAndBodyDataUsedTogether() {
        sut = HttpError.requestFailed(.paramsAndBodyDataUsedTogether)
        XCTAssertEqual(sut.localizedDescription, "Params and bodyData should not be used together in dataRequest")
    }
    
}
