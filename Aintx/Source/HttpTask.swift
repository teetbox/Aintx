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
    
    /* ✅ */
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
                case .data(_):
//                    sessionTask = session.uploadTask(with: request, from: fileData) { (data, response, error) in
//                        let httpResponse = HttpResponse(data: data, response: response, error: error)
//                        completion(httpResponse)
//                    }
                    sessionTask = session.dataTask(with: request) { (data, response, error) in
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
    let completion: ((HttpResponse) -> Void)?
    
    var state: URLSessionTask.State {
        return sessionTask.state
    }
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType, progress: ProgressClosure?, completed:  CompletedClosure?, completion: ((HttpResponse) -> Void)? = nil) {
        self.taskType = taskType
        self.progress = progress
        self.completed = completed
        self.completion = completion
        
        switch taskType {
        case .data:
            fatalError()
        case .file(let fileType):
            switch fileType {
            case .download:
                sessionTask = session.downloadTask(with: request)
            case .upload(let uploadType):
                switch uploadType {
                case .data(_):
                    guard let uploadData = request.httpBody else {
                        fatalError()
                    }
                    sessionTask = session.uploadTask(with: request, from: uploadData) { (data, response, error) in
                        let httpResponse = HttpResponse(data: data, response: response, error: error)
                        print(httpResponse.json as? [String: Any])
                        print((httpResponse.urlResponse as? HTTPURLResponse)?.statusCode)
                        completion?(httpResponse)
                        
                    }
                case .url(let fileURL):
                    sessionTask = session.uploadTask(with: request, fromFile: fileURL)
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
