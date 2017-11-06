//
//  RequestTokenInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class RequestTokenInternalTests: XCTestCase {
    
    func testInit() {
        let requestToken = RequestToken(task: URLSessionTask())
        XCTAssertNotNil(requestToken)
    }
    
}
