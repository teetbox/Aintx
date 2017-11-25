//
//  HttpbinTests.swift
//  AintxTests
//
//  Created by Tong Tian on 10/24/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class HttpbinTests: XCTestCase {
    
    var aintx: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: "https://httpbin.org")
        async = expectation(description: "async")
    }
    
    func testGet() {
        aintx.get("/get") { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
    func testPostWithParams() {
        aintx.post("/post", params: ["foo": "bar"]) { response in
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 200)
            let json = response.json
            
            XCTAssertNotNil(json)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGetWithQueryString() {
        aintx.get("/get", params: ["env": "123"]) { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            let json = response.json!
            let args = json["args"] as! [String: String]
            XCTAssertEqual(args["env"], "123")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGetWithQueryString2() {
        aintx.get("/get?env=123") { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            let json = response.json!
            let args = json["args"] as! [String: String]
            XCTAssertEqual(args["env"], "123")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPost() {
        let params: [String : Any] = ["userId": 88, "id": 108, "title": "TTSY", "body": "Forever"]
        
        aintx.post("/post", params: params) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            guard let json = response.json else {
                return
            }
            print(json["json"] as! Dictionary<String, Any>)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    struct Article: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    
    func testPostWithBodyData() {
        let article = Article(userId: 88, id: 108, title: "TTSY", body: "Forever")
        let jsonData = try! JSONEncoder().encode(article)
        
        aintx.post("/post", bodyData: jsonData) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            guard let json = response.json else {
                XCTFail()
                return
            }
            
            guard let jsonDic = json["json"] as? [String: Any] else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(jsonDic["userId"] as! Int, 88)
            XCTAssertEqual(jsonDic["id"] as! Int, 108)
            XCTAssertEqual(jsonDic["title"] as! String, "TTSY")
            XCTAssertEqual(jsonDic["body"] as! String, "Forever")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testDataRequestWithBodyData() {
        let article = Article(userId: 88, id: 108, title: "TTSY", body: "Forever")
        let jsonData = try! JSONEncoder().encode(article)
        
        aintx
            .dataRequest(path: "/post", method: .post, bodyData: jsonData)
            .go { response in
                XCTAssertNotNil(response.data)
                XCTAssertNil(response.error)
                
                guard let json = response.json else {
                    XCTFail()
                    return
                }
                
                guard let jsonDic = json["json"] as? [String: Any] else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(jsonDic["userId"] as! Int, 88)
                XCTAssertEqual(jsonDic["id"] as! Int, 108)
                XCTAssertEqual(jsonDic["title"] as! String, "TTSY")
                XCTAssertEqual(jsonDic["body"] as! String, "Forever")
                
                self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
}
