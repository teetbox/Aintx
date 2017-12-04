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
    
    func testDownloadFromDropBox() {
        let filePath = "https://www.dropbox.com/s/r6lr4zlw12ipafm/SpeedTracker_movie.mov?dl=1"
        let progress: ProgressClosure = { _, writtenBytes, totalBytes in
            let percentage = writtenBytes / totalBytes * 100
            print("Downloading \(percentage)%")
        }
        
        let task = aintx.download(filePath, progress: progress) { response in
            self.async.fulfill()
        }
        
        sleep(5)
        task.cancel()
        
        wait(for: [async], timeout: 10)
    }
    
}
