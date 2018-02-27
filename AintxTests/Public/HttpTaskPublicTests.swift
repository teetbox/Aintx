//
//  HttpTaskPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpTaskPublicTests: XCTestCase {
    
    var sut: HttpTask!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: fakeBase).get(fakePath) { _ in }
    }

    func testSuspend() {
        sut.suspend()
        XCTAssertEqual(sut.state, .suspended)
    }
    
    func testResume() {
        sut.resume()
        XCTAssertEqual(sut.state, .running)
    }
    
    func testCancel() {
        sut.cancel()
        XCTAssertEqual(sut.state, .canceling)
    }
    
}
