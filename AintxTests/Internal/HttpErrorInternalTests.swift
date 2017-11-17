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
        error = HttpError.invalidURL("~!@#$")
        print(error.localizedDescription)
        XCTAssertEqual(error.localizedDescription, "Invalid URL: '~!@#$'")
    }
    
    func testUnsupportedSession() {
        error = HttpError.unsupportedSession(.dataInBackground)
        XCTAssertEqual(error.localizedDescription, "Data tasks are not supported in background session")
    }
    
}











