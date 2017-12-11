//
//  HttpTask.swift
//  Aintx
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public typealias ProgressHandler = (_ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void

public typealias CompletionHandler = () -> Void

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
