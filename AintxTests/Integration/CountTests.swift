//
//  CountTests.swift
//  AintxTests
//
//  Created by Tong Tian on 07/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

struct User: Decodable {
    let id: Int
    let userName: String
    let eMail: String
    let phone: String
    let userPassword: String
    let createdAt: String
    let updatedAt: String
}

class CountTests: XCTestCase {
    
    var aintx: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: "http://count.aintx.com")
        async = expectation(description: "async")
    }
    
    func testGetUser() {
        aintx.get("/api/v1/user") { response in
            XCTAssertNotNil(response.data)
            
            let decoder = JSONDecoder()
            let _ = try! decoder.decode(Array<User>.self, from: response.data!)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 500)
    }
    
    func testPutUser() {
        let params = ["eMail": "tiantong@aintx.com"]
        
        aintx.put("/api/v1/user/2", params: params) { response in
            let user = try! JSONDecoder().decode(User.self, from: response.data!)
            XCTAssertEqual(user.eMail, "tiantong@aintx.com")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
    func testLogin() {
        let params = ["userName": "tiantong", "userPassword": "happytt"]
        aintx.post("/api/v1/login", params: params) { response in
            let json = response.json
            let token = json?["token"] as? String
            XCTAssertNotNil(token)

            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
}
