//
//  HttpErrorInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 08/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpErrorInternalTests: XCTestCase {
    
    var error: HttpError!
    
    override func setUp() {
        super.setUp()
    }
    
    func testInvalidURL() {
        error = HttpError.requestFailed(.invalidURL("~!@#$"))
        print(error.localizedDescription)
        XCTAssertEqual(error.localizedDescription, "Invalid URL: ~!@#$")
    }
    
    func testUnsupportedSession() {
        error = HttpError.requestFailed(.dataRequestInBackgroundSession)
        XCTAssertEqual(error.localizedDescription, "Data tasks are not supported in background session")
    }
    
    func testParamsAndBodyDataUsedTogether() {
        error = HttpError.requestFailed(.paramsAndBodyDataUsedTogether)
        XCTAssertEqual(error.localizedDescription, "Params and bodyData should not be used together in dataRequest")
    }
    
}
