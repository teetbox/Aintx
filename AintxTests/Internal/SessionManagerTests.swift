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
    var session: URLSession!
    
    let fakeURL = URL(string: "www.fake.com")!
    
    override func setUp() {
        super.setUp()
        
        sut = SessionManager.shared
        session = URLSession.shared
    }

    func testInit() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.tasks)
        XCTAssertEqual(sut.tasks.count, 0)
    }
    
    func testSessionTasks() {
        let sessionTask = session.dataTask(with: fakeURL)
        let httpTask = HttpDataTask(request: URLRequest(url: URL(string: "www.fake.com")!), config: .standard, completion: { _ in })
        
        sut.tasks[sessionTask] = httpTask
        
        XCTAssertNotNil(sut.tasks[sessionTask])
        XCTAssertEqual(sut.tasks.count, 1)
        
        let savedTask = sut.tasks[sessionTask]
        
        XCTAssertNotNil(savedTask)
        XCTAssert(savedTask! is HttpDataTask)
    }

}
