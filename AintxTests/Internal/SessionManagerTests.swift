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
    
    let session = URLSession.shared
    let fakeURL = URL(string: "www.fake.com")!
    
    override func setUp() {
        super.setUp()
        
        sut = SessionManager.shared
    }

    func testShared() {
        XCTAssertNotNil(sut)
    }
    
    func testGetSessionForStandard() {
        let standard = sut.getSession(with: .standard)
        let standard2 = sut.getSession(with: .standard)
        
        XCTAssertEqual(standard, standard2)
    }
    
    func testGetSessionForEphmer() {
        let ephemeral = sut.getSession(with: .ephemeral)
        let ephemeral2 = sut.getSession(with: .ephemeral)
        
        XCTAssertEqual(ephemeral, ephemeral2)
    }
    
    func testGetSessionForBackground() {
        let background = sut.getSession(with: .background("background"))
        let background2 = sut.getSession(with: .background("background"))
        let background3 = sut.getSession(with: .background("background3"))
        
        XCTAssertEqual(background, background2)
        XCTAssertNotEqual(background, background3)
    }
    
    func testSubscript() {
        let sessionTask = session.dataTask(with: fakeURL)
        let httpTask = HttpDataTask(request: URLRequest(url: fakeURL), config: .standard, completion: { _ in })
        
        sut[sessionTask] = httpTask
        
        XCTAssertNotNil(sut[sessionTask])
        XCTAssert(sut[sessionTask] is HttpDataTask)
    }

}
