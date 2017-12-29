//
//  HttpResponseTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/25/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpResponseTests: XCTestCase {
    
    var sut: HttpResponse!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    func testInitWithFakeRequest() {
        var request = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard)
        
        sut = HttpResponse(fakeRequest: request)
        
        XCTAssertEqual(sut.fakeRequest!.base, fakeBase)
        XCTAssertEqual(sut.fakeRequest!.path, fakePath)
        XCTAssertEqual(sut.fakeRequest!.method, .get)
        XCTAssertEqual(sut.fakeRequest!.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertEqual(sut.fakeRequest!.taskType, .data)
        XCTAssertNil(sut.fakeRequest!.params)
        XCTAssertNil(sut.fakeRequest!.headers)
        XCTAssertNil(sut.fakeRequest!.bodyData)
        XCTAssertNotNil(sut.fakeRequest!.urlRequest)
        
        let content = MultiPartContent(name: "", fileName: "", type: .jpg, data: Data())
        request = HttpDataRequest(base: fakeBase, path: fakePath, method: .post, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .background("bg"), taskType: .upload(content))
        
        sut = HttpResponse(fakeRequest: request)
        
        XCTAssertEqual(sut.fakeRequest!.base, fakeBase)
        XCTAssertEqual(sut.fakeRequest!.path, fakePath)
        XCTAssertEqual(sut.fakeRequest!.method, .post)
        XCTAssertEqual(sut.fakeRequest!.session, SessionManager.shared.getSession(with: .background("bg")))
        XCTAssertEqual(sut.fakeRequest!.taskType, .upload(content))
        XCTAssertEqual(sut.fakeRequest!.params!["key"] as! String, "value")
        XCTAssertEqual(sut.fakeRequest!.headers!["key"], "value")
        XCTAssertNil(sut.fakeRequest!.bodyData)
        XCTAssertNotNil(sut.fakeRequest!.urlRequest)
    }
    
}
