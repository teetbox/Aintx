//
//  HttpTaskDelegateTests.swift
//  AintxTests
//
//  Created by Matt Tian on 12/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpTaskDelegateTests: XCTestCase {
    
    var sut: HttpTaskDelegate!
    
    override func setUp() {
        super.setUp()

        sut = HttpTaskDelegate()
    }
    
    func testInit() {
    }
    
    func testInitWithProgressHandlerAndCompletedHandler() {
        let progressHandler: ProgressHandler = { _, _, _ in }
        let completedHandler: CompletedHandler = { _, _ in }
        
        sut = HttpTaskDelegate(progress: progressHandler, completed: completedHandler)
        XCTAssertNotNil(sut.progressHandler)
        XCTAssertNotNil(sut.completedHandler)
    }
    
}
