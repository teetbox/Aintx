//
//  HttpRequest.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public class HttpRequest {
    
    var urlString: String?
    var urlRequest: URLRequest?
    var httpError: HttpError?
    
    let base: String
    let path: String
    let method: HttpMethod
    let params: [String: Any]?
    let headers: [String: String]?
    let session: URLSession
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig) {
        self.base = base
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
        self.session = SessionManager.shared.getSession(with: sessionConfig)

        if case .get = method {
            urlString = try? URLEncording.composeURLString(base: base, path: path, params: params)
        } else {
            urlString = try? URLEncording.composeURLString(base: base, path: path)
        }
        
        guard let urlString = urlString else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            return
        }
        
        guard let url = URL(string: urlString) else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            return
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        
        if let params = params, method != HttpMethod.get {
            urlRequest?.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
    }
    
}

extension HttpRequest {
    
    public func setAuthorization(username: String, password: String) -> Self {
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()

        urlRequest?.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        return self
    }
    
    public func setAuthorization(basicToken: String) -> Self {
        let basic = "Basic "
        var token = basicToken
        if token.hasPrefix(basic) {
            let spaceIndex = token.index(of: " ")!
            token = String(token[spaceIndex...])
        }
        
        urlRequest?.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        return self
    }
    
}

public class HttpDataRequest: HttpRequest {
    
    let bodyData: Data?
    let taskType: TaskType
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, bodyData: Data? = nil, taskType: TaskType = .data) {
        self.bodyData = bodyData
        self.taskType = taskType
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
        
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest?.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyData = bodyData {
            urlRequest?.httpBody = bodyData
        }
    }
    
    @discardableResult
    public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard httpError == nil else {
            completion(HttpResponse(error: httpError))
            return BlankHttpTask()
        }
        
        guard let request = urlRequest else {
            fatalError()
        }
        
        let dataTask = HttpDataTask(request: request, session: session, taskType: taskType, completion: completion)
        dataTask.resume()
        return dataTask
    }
    
}

class HttpDownloadRequest: HttpRequest {
    
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    let completion: ((HttpResponse) -> Void)?
    
    // For session downloadTask with completionHandler
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, progress: ProgressClosure? = nil, completion: @escaping (HttpResponse) -> Void) {
        self.progress = nil
        self.completed = nil
        self.completion = completion
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
    }
    
    // For session downloadTask with delegate
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, progress: ProgressClosure? = nil, completed: CompletedClosure? = nil) {
        self.progress = progress
        self.completed = completed
        self.completion = nil
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
    }
    
    public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        
        guard let urlString = urlString else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            fatalError()
        }
        
        guard let url = URL(string: urlString) else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            fatalError()
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        
        let downloadTask = HttpDownloadTask(urlRequest: urlRequest!, session: session, completion: completion)
        
        return downloadTask
    }
    
}

public class HttpUploadRequest: HttpRequest {
    
    let uploadType: UploadType
    
    init(base: String, path: String, method: HttpMethod, uploadType: UploadType, params: [String: Any]?, headers: [String: String]? = nil, sessionConfig: SessionConfig) {
        self.uploadType = uploadType
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
    }
    
    public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        
//        let uploadTask: URLSessionUploadTask
//
//        switch uploadType {
//        case .data(let fileData):
//            uploadTask = session.uploadTask(with: urlRequest!, from: fileData) { (data, response, error) in
//                let httpResponse = HttpResponse(data: data, response: response, error: error)
//                completion(httpResponse)
//            }
//        case .url(let fileURL):
//            uploadTask = session.uploadTask(with: urlRequest!, fromFile: fileURL) { (data, response, error) in
//                let httpResponse = HttpResponse(data: data, response: response, error: error)
//                completion(httpResponse)
//            }
//        }
//
//        uploadTask.resume()
//        return HttpUploadTask(task: uploadTask)
        
        guard let request = urlRequest else {
            fatalError()
        }
        
        let uploadTask = HttpUploadTask(request: request, session: session, type: uploadType, completion: completion
        )
        return uploadTask
    }
    
}

public typealias ProgressClosure = (Int64, Int64, Int64) -> Void
public typealias CompletedClosure = (URL?, Error?) -> Void

public class HttpLoadRequest: HttpRequest {
    
    var task: HttpDownloadTask?
    
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, progress: ProgressClosure? = nil, completed: CompletedClosure? = nil) {
        self.progress = progress
        self.completed = completed
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)

        guard let urlString = urlString else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            fatalError()
        }
        
        guard let url = URL(string: urlString) else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            fatalError()
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        
        task = HttpDownloadTask(urlRequest: urlRequest!, session: session, progress: progress, completed: completed)
    }
    
    public func go() -> HttpTask {
        return task!.go()
    }
    
}

class FakeDataRequest: HttpDataRequest {

    public override func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        completion(HttpResponse(fakeRequest: self))
        return BlankHttpTask()
    }
    
}

class FakeLoadRequest: HttpLoadRequest {
    
    override init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, progress: ProgressClosure? = nil, completed: CompletedClosure? = nil) {
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig, progress: progress, completed: completed)
        
        guard let urlString = urlString else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            fatalError()
        }
        
        guard let url = URL(string: urlString) else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            fatalError()
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        
        task = HttpDownloadTask(urlRequest: urlRequest!, session: session, progress: progress, completed: completed)
    }
    
    public override func go() -> HttpTask {
        return task!.go()
    }
}
