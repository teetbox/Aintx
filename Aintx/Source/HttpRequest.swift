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
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, session: URLSession) {
        self.base = base
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
        self.session = session

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
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, bodyData: Data? = nil, session: URLSession) {
        self.bodyData = bodyData
        super.init(base: base, path: path, method: method, params: params, headers: headers, session: session)
        
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
            return HttpTask(sessionTask: URLSessionTask())
        }
        
        let dataTask = session.dataTask(with: urlRequest!) { (data, response, error) in
            let httpResponse = HttpResponse(data: data, response: response, error: error)
            completion(httpResponse)
        }
        
        dataTask.resume()
        return HttpTask(sessionTask: dataTask)
    }
    
}

class UploadRequest: HttpRequest {
    
    let uploadType: UploadType
    
    init(base: String, path: String, method: HttpMethod, uploadType: UploadType, params: [String: Any]?, headers: [String: String]? = nil, session: URLSession) {
        self.uploadType = uploadType
        super.init(base: base, path: path, method: method, params: params, headers: headers, session: session)
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
        return HttpTask(sessionTask: uploadTask)
    }
    
}

class DownloadRequest: HttpRequest {
    
    let progressClosure: ProgressClosure?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]? = nil, progress: ProgressClosure? = nil, session: URLSession) {
        self.progressClosure = progress
        super.init(base: base, path: path, method: method, params: params, headers: headers, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        
        guard let filePath = urlString else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            return HttpTask(sessionTask: URLSessionTask())
        }
        
        guard let fileURL = URL(string: filePath) else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            return HttpTask(sessionTask: URLSessionTask())
        }
        
        let downloadTask: URLSessionDownloadTask
        downloadTask = session.downloadTask(with: fileURL)
        downloadTask.resume()
        
        return HttpTask(sessionTask: downloadTask)
    }
    
}

class StreamRequest: HttpRequest {
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, session: URLSession) {
        super.init(base: base, path: path, method: method, params: params, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        fatalError()
    }
    
}

class FakeRequest: HttpRequest {
    
    public var error: HttpError?

    let bodyData: Data?
    let uploadType: UploadType?
    
    init(base: String, path: String, method: HttpMethod, params: [String: Any]? = nil, headers: [String: String]? = nil, bodyData: Data? = nil, uploadType: UploadType? = nil, session: URLSession) {
        self.bodyData = bodyData
        self.uploadType = uploadType
        super.init(base: base, path: path, method: method, params: params, headers: headers, session: session)
        
        guard let url = URL(string: base + path) else {
            error = HttpError.requestFailed(.invalidURL(base + path))
            return
        }
        
        urlRequest = URLRequest(url: url)
    }
    
    public override func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        completion(HttpResponse(fakeRequest: self))
        return HttpTask(sessionTask: URLSessionTask())
    }
    
}
