//
//  HttpTask.swift
//  Aintx
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public protocol HttpTask {
    func suspend()
    func resume()
    func cancel()
}

class HttpDataTask: HttpTask {
    
    var task: URLSessionTask
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    convenience init() {
        self.init(task: URLSessionDataTask())
    }
    
    func suspend() { task.suspend() }
    func resume() { task.resume() }
    func cancel() { task.cancel() }
    
}

class HttpUploadTask: HttpDataTask {
    
    init(task: URLSessionUploadTask) {
        super.init(task: task)
    }
    
    convenience init() {
        self.init(task: URLSessionUploadTask())
    }
    
}

class HttpDownloadTask: HttpTask {
    
    var task: URLSessionTask
    
    init(task: URLSessionDownloadTask) {
        self.task = task
    }
    
    convenience init() {
        self.init(task: URLSessionDownloadTask())
    }
    
    func suspend() { task.suspend() }
    func resume() { task.resume() }
    func cancel() { task.cancel() }
    
}

class HttpTaskDelegate: NSObject, URLSessionDownloadDelegate {
    
    let progress: ProgressHandler
    let completion: CompletionHandler
    
    init(progress: @escaping ProgressHandler, completion: @escaping CompletionHandler) {
        self.progress = progress
        self.completion = completion
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
        progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
        print(location.absoluteString)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
        let httpResponse = HttpResponse(error: error)
        completion(httpResponse)
    }
    
}
