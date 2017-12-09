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
    
    func testDownloadFromDropBox() {
        let filePath = "https://www.dropbox.com/s/r6lr4zlw12ipafm/SpeedTracker_movie.mov?dl=1"
        let progress: ProgressClosure = { _, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading \(String(format: "%.2f", percentage))%")
        }

        let task = aintx.download(filePath, progress: progress) { response in
            self.async.fulfill()
        }

        task.cancel()
        
        wait(for: [async], timeout: 200)
    }
    
}
