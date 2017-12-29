//
//  URLEncodingTests.swift
//  AintxTests
//
//  Created by Tong Tian on 01/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class URLEncodingTests: XCTestCase {
    
    func testEncord() {
        let base = "http://www.fake.com"
        let path = "/fake/path"
        let params: [String: Any] = ["data": "2017-12-29", "length": 12345678910]
        
        let encordedURL = try? URLEncoding.encord(base: base, path: path, params: params)
        XCTAssertNotNil(encordedURL)
    }
    
    func testEncordWithInvalidURL() {
        let fakeBase = ""
        let fakePath = ""
        let params: [String: Any] = ["data": "2017-12-29", "length": 12345678910]
        
        var encordedURL: URL? = nil
        do {
            encordedURL = try URLEncoding.encord(base: fakeBase, path: fakePath, params: params)
        } catch URLEncodingError.invalidBase(let base) {
            XCTAssertEqual(fakeBase, base)
        } catch URLEncodingError.invalidPath(let base) {
            XCTAssertEqual(fakePath, base)
        } catch URLEncodingError.invalidURL(let urlString) {
            XCTAssertEqual(fakePath + fakeBase, urlString)
        } catch URLEncodingError.invalidParams(let parameters) {
            XCTAssertEqual(params.count, parameters.count)
        } catch {
            fatalError()
        }
        
        XCTAssertNil(encordedURL)
    }
    
}
