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

class FakeTask: HttpTask {
    func suspend() {}
    func resume() {}
    func cancel() {}
}

class DataTask: HttpTask {
    
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

protocol Combinable {
    
}

protocol CombinableTask: HttpTask, Combinable {
    func go() -> HttpTask
}

class UploadTask: DataTask, CombinableTask {

    init(task: URLSessionUploadTask) {
        super.init(task: task)
    }
    
    func go() -> HttpTask {
        return self
    }

}

class DownloadTask: HttpTask, CombinableTask {
    
    var task: URLSessionTask?
    
    let urlRequest: URLRequest
    let sessionConfig: SessionConfig
    
    let progressHandler: ProgressHandler?
    let completedHandler: CompletedHandler?
    
    init(urlRequest: URLRequest, sessionConfig: SessionConfig, progress: ProgressHandler?, completed: CompletedHandler?) {
        self.urlRequest = urlRequest
        self.sessionConfig = sessionConfig
        self.progressHandler = progress
        self.completedHandler = completed
    }
    
    func go() -> HttpTask {
        task?.resume()
        return self
    }
    
    func suspend() { task?.suspend() }
    func resume() { task?.resume() }
    func cancel() { task?.cancel() }
    
}
