//
//  URLEncordingTests.swift
//  AintxTests
//
//  Created by Tong Tian on 01/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class URLEncordingTests: XCTestCase {
    
    func testEncord() {
        let base = "https://api.nasa.gov"
        let path = "/planetary/earth/imagery"
        let params: [String : Any] = ["lon": 100.75, "lat": 1.5, "date": "2014-02-01", "cloud_score": true, "api_key": "DEMO_KEY"]
        
        let urlString = try! URLEncording.composeURLString(base: base, path: path, params: params)
        XCTAssert(urlString.contains("https://api.nasa.gov/planetary/earth/imagery?"))
        XCTAssert(urlString.contains("lon=100.75"))
        XCTAssert(urlString.contains("lat=1.5"))
        XCTAssert(urlString.contains("date=2014-02-01"))
        XCTAssert(urlString.contains("cloud_score=true"))
        XCTAssert(urlString.contains("api_key=DEMO_KEY"))
    }
    
}
