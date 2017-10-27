//
//  HttpRequestInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpRequestInternalTests: XCTestCase {
    
    var dataRequest: HttpDataRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
    }
    
    func testInit() {
        dataRequest = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, queryDic: nil, paramDic: nil, session: URLSession.shared)
        
        XCTAssertEqual(dataRequest.base, fakeBase)
        XCTAssertEqual(dataRequest.path, fakePath)
        XCTAssertEqual(dataRequest.method, .get)
    }
    
}
