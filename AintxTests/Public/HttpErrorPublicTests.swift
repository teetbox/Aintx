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
    
    var aintx: Aintx!
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: fakeBase)
        aintx.isFake = true
    }
    
    func testDataRequestInBackgroundSession() {
        aintx = Aintx(base: fakeBase, config: .background("bg"))
        aintx.isFake = false
        aintx.get(fakePath) { response in
            print("++++++++++++++++++++++++++++++++++")
            print(response.error!.localizedDescription)
            print("++++++++++++++++++++++++++++++++++")
        }
    }
    
    func testInvalidURL() {

    }
    
}
