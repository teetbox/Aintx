//
//  HttpRequest.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public class HttpRequest {
    
    var urlRequest: URLRequest?
    var httpError: HttpError?
    
    let base: String
    let path: String
    let params: [String: Any]?
    let method: HttpMethod
    let session: URLSession
    
    init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        self.base = base
        self.path = path
        self.params = params
        self.method = method
        self.session = session
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
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
        
        guard let url = URL(string: base + path) else {
            httpError = HttpError.invalidURL(base + path)
            return
        }
        
        do {
            _ = try URLEncording.encord(base: base, path: path)
        } catch {
            httpError = error as? HttpError
            return
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let params = params else { return }
        let body = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        urlRequest?.httpBody = body
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

class DownloadRequest: HttpRequest {
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        fatalError()
    }
    
}

class UploadRequest: HttpRequest {
    
    let uploadType: UploadType
    
    init(base: String, path: String, uploadType: UploadType, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        self.uploadType = uploadType
        
        super.init(base: base, path: path, params: params, method: method, session: session)
        
        guard let url = URL(string: base + path) else {
            httpError = HttpError.invalidURL(base + path)
            return
        }
        
        do {
            _ = try URLEncording.encord(base: base, path: path)
        } catch {
            httpError = error as? HttpError
            return
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let params = params else { return }
        let body = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        urlRequest?.httpBody = body
        
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

class StreamRequest: HttpRequest {
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        fatalError()
    }
    
}

class FakeRequest: HttpRequest {
    
    public var error: HttpError?
    
    let uploadType: UploadType?
    
    init(base: String, path: String, params: [String: Any]?, method: HttpMethod, uploadType: UploadType? = nil, session: URLSession) {
        self.uploadType = uploadType
        
        super.init(base: base, path: path, params: params, method: method, session: session)
        
        guard let url = URL(string: base + path) else {
            error = HttpError.invalidURL(base + path)
            return
        }
        
        urlRequest = URLRequest(url: url)
    }
    
    public override func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        completion(HttpResponse(fakeRequest: self))
        return HttpTask(sessionTask: URLSessionTask())
    }
    
}
