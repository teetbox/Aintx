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

    public func go(completion: @escaping (HttpResponse) -> Void) {
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
    
    public var error: HttpError?
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
        
        guard let url = URL(string: base + path) else {
            error = HttpError.invalidURL(base + path)
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
    
    public override func go(completion: @escaping (HttpResponse) -> Void) {
        guard error == nil else {
            completion(HttpResponse(error: error))
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest!) { (data, response, error) in
            let httpResponse = HttpResponse(data: data, response: response, error: error)
            completion(httpResponse)
        }
        
        dataTask.resume()
    }
    
}

class DownloadRequest: HttpRequest {
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) {
        
    }
    
}

class UploadRequest: HttpRequest {
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) {
        
    }
    
}

class StreamRequest: HttpRequest {
    
    override init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        super.init(base: base, path: path, params: params, method: method, session: session)
    }
    
    override public func go(completion: @escaping (HttpResponse) -> Void) {
        
    }
    
}

class FakeRequest: HttpRequest {

    let type: TaskType
    
    public var error: HttpError?
    
    init(base: String, path: String, params: [String: Any]?, method: HttpMethod, type: TaskType, session: URLSession) {
        self.type = type

        super.init(base: base, path: path, params: params, method: method, session: session)
        
        guard let url = URL(string: base + path) else {
            error = HttpError.invalidURL(base + path)
            return
        }
        
        urlRequest = URLRequest(url: url)
    }
    
    public override func go(completion: @escaping (HttpResponse) -> Void) {
        let response = HttpResponse(fakeRequest: self)
        completion(response)
    }
    
}
