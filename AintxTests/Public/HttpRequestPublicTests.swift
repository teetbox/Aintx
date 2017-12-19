//
//  HttpRequestPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 23/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpRequestPublicTests: XCTestCase {
    
    var sut: HttpRequest!
    var aintx: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()

        aintx = Aintx(base: fakeBase)
        sut = aintx.dataRequest(path: fakePath)
    }
    
    func testGoForDataRequest() {
        let task = (sut as! HttpDataRequest).go(completion: { _ in })
        XCTAssertNotNil(task)
    }
    
    func testGoForDataRequestWithParamsAndBodyData() {
        sut = aintx.dataRequest(path: fakePath, method: .post, params: ["key": "value"], headers: ["key": "value"], bodyData: Data())
        XCTAssertNotNil(sut)
        
        let task = (sut as! HttpDataRequest).go { response in
            XCTAssertNotNil(response.error)
            XCTAssertEqual(response.error?.localizedDescription, "Params and bodyData should not be used together in dataRequest")
        }
        XCTAssertNotNil(task)
    }
    
    func testGoForFileRequest() {
        sut = aintx.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        let task = (sut as! HttpFileRequest).go()
        XCTAssertNotNil(task)
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        sut = sut.setAuthorization(username: "username", password: "password")
        XCTAssertNotNil(sut)
    }
    
    func testSetAuthorizationWithBasicToken() {
        sut = sut.setAuthorization(basicToken: "Basic ABCDEFG")
        XCTAssertNotNil(sut)
    }
    
}
