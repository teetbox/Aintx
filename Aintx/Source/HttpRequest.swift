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
    let sessionConfig: SessionConfig
    let session: URLSession
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, sessionConfig: SessionConfig) {
        self.base = base
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
        self.sessionConfig = sessionConfig
        self.session = SessionManager.shared.getSession(with: self.sessionConfig)

        if case .get = method {
            urlString = try? URLEncording.composeURLString(base: base, path: path, params: params)
        } else {
            urlString = try? URLEncording.composeURLString(base: base, path: path)
        }
    }

    @discardableResult
    public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        fatalError("Must be overrided by subclass!")
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

class DataRequest: HttpRequest {
    
    let bodyData: Data?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, bodyData: Data? = nil, sessionConfig: SessionConfig) {
        self.bodyData = bodyData
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
        
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
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest?.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let params = params, method != HttpMethod.get {
            urlRequest?.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        if let bodyData = bodyData {
            urlRequest?.httpBody = bodyData
        }
    }
    
    public override func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard httpError == nil else {
            completion(HttpResponse(error: httpError))
            return DataTask()
        }
        
        let dataTask = session.dataTask(with: urlRequest!) { (data, response, error) in
            let httpResponse = HttpResponse(data: data, response: response, error: error)
            completion(httpResponse)
        }
        
        dataTask.resume()
        return DataTask(task: dataTask)
    }
    
}

class UploadRequest: HttpRequest {
    
    let uploadType: UploadType
    
    init(base: String, path: String, method: HttpMethod, uploadType: UploadType, params: [String: Any]?, headers: [String: String]? = nil, sessionConfig: SessionConfig) {
        self.uploadType = uploadType
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        
        let uploadTask: URLSessionUploadTask
        
        switch uploadType {
        case .data(let fileData):
            uploadTask = session.uploadTask(with: urlRequest!, from: fileData) { (data, response, error) in
                let httpResponse = HttpResponse(data: data, response: response, error: error)
                completion(httpResponse)
            }
        case .url(let fileURL):
            uploadTask = session.uploadTask(with: urlRequest!, fromFile: fileURL) { (data, response, error) in
                let httpResponse = HttpResponse(data: data, response: response, error: error)
                completion(httpResponse)
            }
        }
        
        uploadTask.resume()
        return UploadTask(task: uploadTask)
    }
    
}

class DownloadRequest: HttpRequest {
    
    let progressHandler: ProgressHandler?
    let completedHandler: CompletedHandler?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, progress: ProgressHandler? = nil, completion: (HttpResponse) -> Void, sessionConfig: SessionConfig) {
        self.progressHandler = progress
        self.completedHandler = nil
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        

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
        let downloadTask = session.downloadTask(with: urlRequest!) { (url, response, error) in
            let httpResponse = HttpResponse(data: nil, response: response, error: error)
            completion(httpResponse)
        }
        downloadTask.resume()
        
        return DataTask()
    }
    
}

class StreamRequest: HttpRequest {
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, sessionConfig: SessionConfig) {
        super.init(base: base, path: path, method: method, params: params, sessionConfig: sessionConfig)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        fatalError()
    }
    
}

public typealias ProgressHandler = (Int64, Int64, Int64) -> Void
public typealias CompletedHandler = (URL?, Error?) -> Void

public class HttpLoadRequest: HttpRequest {
    
    var task: CombinableTask?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, progress: ProgressHandler? = nil, completed: CompletedHandler? = nil, sessionConfig: SessionConfig) {
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
        self.task = DownloadTask(urlRequest: urlRequest!, sessionConfig: sessionConfig, progress: progress, completed: completed)
    }
    
    public func go() -> HttpTask {
        return task!.go()
    }
    
}

class FakeRequest: HttpRequest {
    
    public var error: HttpError?

    let bodyData: Data?
    let uploadType: UploadType?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]? = nil, headers: [String: String]? = nil, bodyData: Data? = nil, uploadType: UploadType? = nil, sessionConfig: SessionConfig) {
        self.bodyData = bodyData
        self.uploadType = uploadType
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
        
        guard let url = URL(string: base + path) else {
            error = HttpError.requestFailed(.invalidURL(base + path))
            return
        }
        
        urlRequest = URLRequest(url: url)
    }
    
    public override func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        completion(HttpResponse(fakeRequest: self))
        return DataTask()
    }
    
}
