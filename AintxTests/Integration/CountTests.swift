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
    let eMail: String?
    let phone: String?
    let userPassword: String
    let token: String?
    let createdAt: String
    let updatedAt: String
}

class CountTests: XCTestCase {
    
    var sut: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: "http://count.aintx.com")
        async = expectation(description: "async")
    }
    
    func testLogin() {
        let params = ["userName": "tiantong", "password": "happytt"]
        sut.post("/api/v1/login", params: params) { response in
            let json = response.json
            let token = json?["token"] as? String
            XCTAssertNotNil(token)
            print(token!)
            
            
            let httpResponse = response.urlResponse as? HTTPURLResponse
            print(httpResponse!.allHeaderFields)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 30)
    }
    
    func testGetUser() {
        let params = ["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTmFtZSI6ImhhcHB5dHQiLCJ1c2VySWQiOjIsImlhdCI6MTUxNDY0NDE1NCwiZXhwIjoxNTE0NjQ3NzU0fQ.ui07f-gFn2ksKeCXQcu0oOg-f7mw3zT2z0g0jagm188"]
        sut.get("/api/v1/user", params: params) { response in
            XCTAssertNotNil(response.data)

            let decoder = JSONDecoder()
            let users = try! decoder.decode([User].self, from: response.data!)
            print(users)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 500)
    }
    
    func testPutUser() {
        let params = ["eMail": "tiantong@aintx.com", "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTmFtZSI6ImhhcHB5dHQiLCJ1c2VySWQiOjIsImlhdCI6MTUxMzI2MDAzOSwiZXhwIjoxNTEzMjYzNjM5fQ.xMjRTketOJ3DN1G0Pt6b8yZySODKcsGWiuT21CP6Ne4"]
        
        sut.put("/api/v1/user/2", params: params) { response in
            let user = try! JSONDecoder().decode(User.self, from: response.data!)
            XCTAssertEqual(user.eMail, "tiantong@aintx.com")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
    func testRegister() {
        let params = ["userName": "tiantong", "password": "happytt"]
        
        sut.post("/api/v1/register", params: params) { response in
            let jsonDic = response.json
            XCTAssertNotNil(jsonDic)
            
            print(jsonDic!)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
}
