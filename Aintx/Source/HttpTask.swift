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

public class HttpDataTask: HttpTask {
    
    let task: URLSessionDataTask
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    public func suspend() {
        task.suspend()
    }
    
    public func resume() {
        task.resume()
    }
    
    public func cancel() {
        task.cancel()
    }
    
}

public class HttpUploadTask: HttpTask {
    let task: URLSessionUploadTask
    
    init(task: URLSessionUploadTask) {
        self.task = task
    }
    
    public func suspend() {
        task.suspend()
    }
    
    public func resume() {
        task.resume()
    }
    
    public func cancel() {
        task.cancel()
    }
    
}

public class HttpDownloadTask: HttpTask {
    let task: URLSessionDownloadTask
    
    init(task: URLSessionDownloadTask) {
        self.task = task
    }
    
    public func suspend() {
        task.suspend()
    }
    
    public func resume() {
        task.resume()
    }
    
    public func cancel() {
        task.cancel()
    }
    
}
