//
//  AintxInternalTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/24/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class AintxInternalTests: XCTestCase {
    
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }
    
    func testInit() {
        XCTAssertEqual(aintx.base, fakeBase)
        XCTAssertEqual(aintx.config, .standard)
    }
    
    func testDefaultSessionConfig() {
        XCTAssertEqual(aintx.session, URLSession.shared)
    }
    
    func testBackgroundSessionConfig() {
        aintx = Aintx(base: fakeBase, config: .background("background"))
        XCTAssertEqual(aintx.session.configuration.identifier, "background")
    }
    
    func testEphemeralSessionConfig() {
        aintx = Aintx(base: fakeBase, config: .ephemeral)
        let aintx2 = Aintx(base: fakeBase, config: .ephemeral)

        XCTAssertNotEqual(aintx.session.configuration, aintx2.session.configuration)
    }
    
}
