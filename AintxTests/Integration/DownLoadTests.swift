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
    
    var sut: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: "")
        async = expectation(description: "async")
    }
    
    func testDownload() {
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        
        sut.download(filePath) { response in
            XCTAssertNil(response.data)
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.urlResponse)
            XCTAssertNotNil(response.url)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 200)
    }
    
    func testFileRequestForDownload() {
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading file \(String(format: "%.2f", percentage))%")
        }
        
        let completed: CompletedClosure = { url, error in
            print("Downloading file Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Downloading file Completed with error: - \(error?.localizedDescription ?? "nil")")
            self.async.fulfill()
        }
        
        let request = sut.fileRequest(downloadPath: filePath, progress: progress, completed: completed)
        request.go()
        
        wait(for: [async], timeout: 200)
    }
    
    func testRequestGroupForDownload() {
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading file 1 \(String(format: "%.2f", percentage))%")
        }
        
        let completed: CompletedClosure = { url, error in
            print("Downloading file 1 Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Downloading file 1 Completed with error: - \(error?.localizedDescription ?? "nil")")
        }
        
        let progress2: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading file 2 \(String(format: "%.2f", percentage))%")
        }
        
        let completed2: CompletedClosure = { url, error in
            print("Downloading file 2 Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Downloading file 2 Completed with error: - \(error?.localizedDescription ?? "nil")")
        }
        
        let progress3: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading file 3 \(String(format: "%.2f", percentage))%")
        }
        
        let completed3: CompletedClosure = { url, error in
            print("Downloading file 3 Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Downloading file 3 Completed with error: - \(error?.localizedDescription ?? "nil")")
            self.async.fulfill()
        }

        let request = sut.fileRequest(downloadPath: filePath, progress: progress, completed: completed)
        let request2 = sut.fileRequest(downloadPath: filePath, progress: progress2, completed: completed2)
        let request3 = sut.fileRequest(downloadPath: filePath, progress: progress3, completed: completed3)
        let tasks = (request --> request2 --> request3).go()

        XCTAssertEqual(tasks.count, 3)
        wait(for: [async], timeout: 200)
    }

}
