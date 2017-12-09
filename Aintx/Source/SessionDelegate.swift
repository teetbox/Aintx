//
//  SessionDelegate.swift
//  Aintx
//
//  Created by Tong Tian on 05/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

class DownloadTaskDelegate: NSObject, URLSessionDownloadDelegate {
    
    override init() {
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
        print(#function)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
    }
    
}
