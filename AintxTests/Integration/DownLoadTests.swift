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
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let progress: ProgressHandler = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading \(String(format: "%.2f", percentage))%")
        }

        let task = aintx.download(filePath, progress: progress) { response in
            self.async.fulfill()
        }

        task.cancel()
        
        wait(for: [async], timeout: 200)
    }
    
    func testDownload() {
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let progress: ProgressHandler = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Downloading \(String(format: "%.2f", percentage))%")
        }
        
        let completion: () -> Void = {
            self.async.fulfill()
        }
        
        let session = URLSession(configuration: .default, delegate: DownloadDelegate(progress: progress, completion: completion), delegateQueue: nil)
        
        session.downloadTask(with: URL(string: filePath)!).resume()
        wait(for: [async], timeout: 20)
    }
    
}

class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    
    let progress: ProgressHandler
    let completion: () -> Void
    
    init(progress: @escaping ProgressHandler, completion: @escaping () -> Void) {
        self.progress = progress
        self.completion = completion
        super.init()
        print("Download delegate init")
    }
    
    deinit {
        print("Download delegate deinit")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print(#function)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
        completion()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
    }
}
