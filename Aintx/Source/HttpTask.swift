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

class FakeHttpTask: HttpTask {
    func suspend() {}
    func resume() {}
    func cancel() {}
}

class HttpDataTask: HttpTask {
    
    let sessionTask: URLSessionTask
    let sessionManager = SessionManager.shared
    
    init(request: URLRequest, config: SessionConfig, completion: @escaping (HttpResponse) -> Void) {
        let session = sessionManager.getSession(with: config)
        
        sessionTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            let httpResponse = HttpResponse(data: data, response: response, error: error)
            completion(httpResponse)
        })
        sessionTask.resume()
    }
    
    func suspend() {
        sessionTask.suspend()
    }
    
    func resume() {
        sessionTask.resume()
    }
    
    func cancel() {
        sessionTask.cancel()
    }
    
}

protocol Combinable {
    
}

protocol CombinableTask: HttpTask, Combinable {
    func go() -> HttpTask
}

class HttpUploadTask: HttpDataTask, CombinableTask {
    
    let type: UploadType
    
    init(request: URLRequest, config: SessionConfig, type: UploadType, completion: @escaping (HttpResponse) -> Void) {
        self.type = type
        super.init(request: request, config: config, completion: completion)
    }
    
    func go() -> HttpTask {
        return self
    }
    
}

class HttpDownloadTask: HttpTask, CombinableTask {
    
    var task: URLSessionTask?
    
    let urlRequest: URLRequest
    let sessionConfig: SessionConfig
    
    let progressHandler: ProgressClosure?
    let completedHandler: CompletedClosure?
    let completionHandler: ((HttpResponse) -> Void)?
    
    init(urlRequest: URLRequest, sessionConfig: SessionConfig, progress: ProgressClosure?, completed: CompletedClosure?) {
        self.urlRequest = urlRequest
        self.sessionConfig = sessionConfig
        self.progressHandler = progress
        self.completedHandler = completed
        self.completionHandler = nil
    }
    
    init(urlRequest: URLRequest, sessionConfig: SessionConfig, completion: @escaping (HttpResponse) -> Void) {
        self.urlRequest = urlRequest
        self.sessionConfig = sessionConfig
        self.progressHandler = nil
        self.completedHandler = nil
        self.completionHandler = completion
    }
    
    func go() -> HttpTask {
        task?.resume()
        return self
    }
    
    func suspend() { task?.suspend() }
    func resume() { task?.resume() }
    func cancel() { task?.cancel() }
    
}
