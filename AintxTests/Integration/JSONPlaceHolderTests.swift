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
    
    var aintx: Aintx!
    var async: XCTestExpectation!
    
    struct Post: Codable {
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
        
        aintx = Aintx(base: "https://jsonplaceholder.typicode.com")
        async = expectation(description: "async")
    }
    
    func testSimpleGet() {
        aintx.get("/posts/1") { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            let post = try! JSONDecoder().decode(Post.self, from: response.data!)
            XCTAssertEqual(post.id, 1)
            XCTAssertEqual(post.userId, 1)
            XCTAssertEqual(post.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
    func testPost() {
        let post = Post(userId: 88, id: 88, title: "TTST", body: "Forever")
        let jsonData = try! JSONEncoder().encode(post)
        let params = ["body": jsonData]
        
        aintx.post("/posts", params: params) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 5)
    }
    
}
