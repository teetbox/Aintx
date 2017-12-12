//
//  DownLoadTests.swift
//  AintxTests
//
//  Created by Tong Tian on 12/1/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

class DownLoadTests: XCTestCase {
    
    var aintx: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        aintx = Aintx(base: "")
        async = expectation(description: "async")
    }
    
    override func tearDown() {
        super.tearDown()
        
        aintx = nil
        print("Set aintx to nil")
    }
    
    func testDownloadTasks() {
//        let request = aintx.downloadRequest()
//        let request2 = aintx.downloadRequest()
//        let request3 = aintx.downloadRequest()
//        
//        (request --> request2 --> request3).go
//        (request ||| request2 ||| request3).go
    }
    
    func testDownloadSwift4() {
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let progress: ProgressHandler = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading \(String(format: "%.2f", percentage))%")
        }
        
        let completed: CompletedHandler = { _, _ in
            self.async.fulfill()
        }

        let downloadTask = aintx.downloadRequest(path: filePath, progress: progress, completed: completed)
        downloadTask.go()
        
        wait(for: [async], timeout: 200)
    }

}
