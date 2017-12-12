//
//  HttpTaskDelegate.swift
//  Aintx
//
//  Created by Matt Tian on 12/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

class HttpTaskDelegate: NSObject, URLSessionDownloadDelegate {
    
    let progressHandler: ProgressHandler?
    let completedHandler: CompletedHandler?
    
    init(progress: ProgressHandler? = nil, completed: CompletedHandler? = nil) {
        self.progressHandler = progress
        self.completedHandler = completed
        super.init()
        print("HttpTaskDelegate init")
    }
    
    deinit {
        print("HttpTaskDelegate deinit")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print(#function)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressHandler?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
        completedHandler?(location, nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
        completedHandler?(nil, error)
    }
    
}
