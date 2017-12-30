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
    case download
    case upload(MultiPartContent)
}

public protocol HttpTask {
    var state: TaskState { get }
    
    func suspend()
    func resume()
    func cancel()
}

class BlankHttpTask: HttpTask {
    var state: TaskState {
        return .suspended
    }
    
    func suspend() {}
    func resume() {}
    func cancel() {}
}

public enum TaskState {
    case running
    case suspended
    case canceling
    case completed
    
    init(_ sessionTask: URLSessionTask) {
        switch sessionTask.state {
        case .running:
            self = .running
        case .suspended:
            self = .suspended
        case .canceling:
            self = .canceling
        case .completed:
            self = .completed
        }
    }
}

class HttpDataTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    var state: TaskState {
        return TaskState(sessionTask)
    }
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType = .data, completion: @escaping (HttpResponse) -> Void) {
        
        switch taskType {
        case .data:
            sessionTask = session.dataTask(with: request) { (data, response, error) in
                let httpResponse = HttpResponse(data: data, response: response, error: error)
                completion(httpResponse)
            }
        case .download:
            sessionTask = session.downloadTask(with: request) { (url, response, error) in
                let httpResponse = HttpResponse(url: url, response: response, error: error)
                completion(httpResponse)
            }
        case .upload(let content):
            if let url = content.url {
                sessionTask = session.uploadTask(with: request, fromFile: url) { (data, response, error) in
                    let httpResponse = HttpResponse(data: data, response: response, error: error)
                    completion(httpResponse)
                }
            } else {
                sessionTask = session.uploadTask(with: request, from: request.httpBody) { (data, response, error) in
                    let httpResponse = HttpResponse(data: data, response: response, error: error)
                    completion(httpResponse)
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

extension HttpFileTask: Hashable {
    var hashValue: Int {
        return sessionTask.taskIdentifier
    }
    
    static func ==(lhs: HttpFileTask, rhs: HttpFileTask) -> Bool {
        return lhs.sessionTask == rhs.sessionTask
    }
}

class HttpFileTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    let taskType: TaskType
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    
    var state: TaskState {
        return TaskState(sessionTask)
    }
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType, progress: ProgressClosure?, completed:  CompletedClosure?) {
        self.taskType = taskType
        self.progress = progress
        self.completed = completed
        
        switch taskType {
        case .data:
            // No need for data taskType
            fatalError("HttpFileTask only could be initialized by download or upload tsakType")
        case .download:
            sessionTask = session.downloadTask(with: request)
        case .upload(let content):
            if let url = content.url {
                sessionTask = session.uploadTask(with: request, fromFile: url)
            } else {
                guard let bodyData = request.httpBody else {
                    fatalError("Upload task from bodyData needs request's httpBody")
                }
                sessionTask = session.uploadTask(with: request, from: bodyData)
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
