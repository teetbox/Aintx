//
//  SessionManagerTests.swift
//  AintxTests
//
//  Created by Tong Tian on 12/10/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class SessionManagerTests: XCTestCase {
    
    var sut: SessionManager!
    
    override func setUp() {
        super.setUp()
        
        sut = SessionManager.shared
    }

    func testInit() {
        XCTAssertNotNil(sut)
        XCTAssertNil(sut.sessionTasks)
    }
    
    func testSessionDelegate() {

    }

}
