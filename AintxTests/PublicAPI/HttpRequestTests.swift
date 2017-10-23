//
//  HttpRequestTests.swift
//  AintxTests
//
//  Created by Tong Tian on 23/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpRequestTests: XCTestCase {
    
    var httpRequest: HttpRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        httpRequest = HttpDataRequest(base: fakeBase, path: fakePath, queryString: nil, parameters: nil, session: URLSession.shared)
    }

    
}
