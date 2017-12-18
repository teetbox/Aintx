//
//  HttpTask.swift
//  Aintx
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

enum TaskType {
    case data
    case file(FileType)
    
    enum FileType {
        case download
        case upload(UploadType)
    }
}

public protocol HttpTask {
    func suspend()
    func resume()
    func cancel()
}

class BlankHttpTask: HttpTask {
    func suspend() {}
    func resume() {}
    func cancel() {}
}

class HttpDataTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    init(request: URLRequest, session: URLSession, taskType: TaskType = .data, completion: @escaping (HttpResponse) -> Void) {
        
        switch taskType {
        case .data:
            sessionTask = session.dataTask(with: request) { (data, response, error) in
                let httpResponse = HttpResponse(data: data, response: response, error: error)
                completion(httpResponse)
            }
        case .file(let fileType):
            switch fileType {
            case .download:
                sessionTask = session.downloadTask(with: request) { (url, response, error) in
                    let httpResponse = HttpResponse(data: nil, response: response, error: error)
                    completion(httpResponse)
                }
            case .upload(let uploadType):
                switch uploadType {
                case .data(let fileData):
                    sessionTask = session.uploadTask(with: request, from: fileData) { (data, response, error) in
                        let httpResponse = HttpResponse(data: data, response: response, error: error)
                        completion(httpResponse)
                    }
                case .url(let fileURL):
                    sessionTask = session.uploadTask(with: request, fromFile: fileURL) { (data, response, error) in
                        let httpResponse = HttpResponse(data: data, response: response, error: error)
                        completion(httpResponse)
                    }
                }
            }
        }
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

class HttpFileTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    
    init(request: URLRequest, session: URLSession, progress: ProgressClosure?, completed:  CompletedClosure?) {
        self.progress = progress
        self.completed = completed
        
        sessionTask = session.downloadTask(with: request)
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

class HttpDownloadTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    let progressHandler: ProgressClosure?
    let completedHandler: CompletedClosure?
    let completionHandler: ((HttpResponse) -> Void)?
    
    init(request: URLRequest, session: URLSession, progress: ProgressClosure?, completed:  CompletedClosure?) {
        self.progressHandler = progress
        self.completedHandler = completed
        self.completionHandler = nil
        
        sessionTask = session.downloadTask(with: request)
    }
    
    init(urlRequest: URLRequest, session: URLSession, progress: ProgressClosure?, completed: CompletedClosure?) {
        self.progressHandler = progress
        self.completedHandler = completed
        self.completionHandler = nil
        
        sessionTask = session.downloadTask(with: urlRequest)
    }
    
    init(urlRequest: URLRequest, session: URLSession, completion: @escaping (HttpResponse) -> Void) {
        self.progressHandler = nil
        self.completedHandler = nil
        self.completionHandler = completion
        
        sessionTask = session.downloadTask(with: urlRequest)
    }
    
    func go() -> HttpTask {
        sessionTask.resume()
        return self
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
