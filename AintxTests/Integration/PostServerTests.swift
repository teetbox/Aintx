//
//  PostServerTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/27/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class PostServerTests: XCTestCase {
    
    var aintx: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: "https://www.posttestserver.com")
        async = expectation(description: "async")
    }
    
}
