//
//  HttpErrorPublicTests.swift
//  AintxTests
//
//  Created by Tong Tian on 08/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpErrorPublicTests: XCTestCase {
    
    var sut: Aintx!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: fakeBase)
    }
    
    func testDataRequestInBackgroundSession() {
        sut = Aintx(base: fakeBase, config: .background("bg"))
        sut.get(fakePath) { response in
            XCTAssertEqual(response.error?.localizedDescription, "Data tasks are not supported in background session")
        }
    }
    
    func testDataRequestHaveParamsAndBodyData() {
        let request = sut.dataRequest(path: fakePath, method: .post, params: ["paramKey": "paramValue"], bodyData: Data())
        request.go { response in
            XCTAssertEqual(response.error?.localizedDescription, "Params and bodyData should not be used together in dataRequest")
        }
    }
    
    func testInvalidURL() {

    }
    
}
