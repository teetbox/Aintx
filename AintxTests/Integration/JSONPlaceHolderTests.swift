//
//  JSONPlaceHolderTests.swift
//  AintxTests
//
//  Created by Tong Tian on 11/23/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class JSONPlaceHolderTests: XCTestCase {
    
    var sut: Aintx!
    var async: XCTestExpectation!
    
    struct Article: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
        
        enum CodingKeys: String, CodingKey {
            case userId
            case id
            case title
            case body
        }
    }
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: "https://jsonplaceholder.typicode.com")
        async = expectation(description: "async")
    }
    
    func testSimpleGet() {
        sut.get("/posts/1") { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            let article = try! JSONDecoder().decode(Article.self, from: response.data!)
            XCTAssertEqual(article.id, 1)
            XCTAssertEqual(article.userId, 1)
            XCTAssertEqual(article.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGet() {
        sut.get("/comments?postId=1") { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGetWithParams() {
        sut.get("/comments", params: ["postId": 1]) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPost() {
        let params: [String : Any] = ["userId": 88, "id": 108, "title": "TTSY", "body": "Forever"]
        
        sut.post("/posts", params: params) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            let json = response.json
            XCTAssertEqual(json!["id"] as! Int, 108)
            XCTAssertEqual(json!["title"] as! String, "TTSY")
            XCTAssertEqual(json!["body"] as! String, "Forever")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPostWithBodyData() {
        let article = Article(userId: 88, id: 108, title: "TTSY", body: "Forever")
        let jsonData = try! JSONEncoder().encode(article)

        sut.post("/posts", bodyData: jsonData) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)

            let json = response.json
            XCTAssertEqual(json!["id"] as! Int, 108)
            XCTAssertEqual(json!["userId"] as! Int, 88)
            XCTAssertEqual(json!["title"] as! String, "TTSY")
            XCTAssertEqual(json!["body"] as! String, "Forever")

            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testDataRequestWithBodyData() {
        let article = Article(userId: 88, id: 108, title: "TTSY", body: "Forever")
        let jsonData = try! JSONEncoder().encode(article)
        
        sut.dataRequest(path: "/posts", method: .post, bodyData: jsonData).go { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)

            let json = response.json
            XCTAssertEqual(json!["id"] as! Int, 108)

            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
}
