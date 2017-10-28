//
//  HttpRequest.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public protocol HttpRequest {

    var urlRequest: URLRequest? { get set }
    var error: HttpError? { get set  }
    
    func go(completion: @escaping (HttpResponse) -> Void)
    
    mutating func setAuthorization(username: String, password: String)
    mutating func setAuthorization(basicToken: String) -> Self
}

extension HttpRequest {
    
    public mutating func setAuthorization(username: String, password: String) {
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()

        urlRequest?.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    }
    
}

public struct HttpDataRequest: HttpRequest {
    
    public let base: String
    public let path: String
    public let method: HttpMethod
    public let session: URLSession

    public var paramDic: [String: Any]?
    
    public var urlRequest: URLRequest?
    public var error: HttpError?
    
    public var base64LoginString: String?
    
    init(base: String, path: String, params: [String: Any]?, method: HttpMethod, session: URLSession) {
        self.base = base
        self.path = path
        self.method = method
        self.session = session
        
        guard let url = URL(string: base + path) else {
            error = HttpError.invalidURL(base + path)
            return
        }
        
        do {
            let _ = try URLEncording.encord(urlString: base + path, method: .get, paramDic: nil)
        } catch {
            self.error = error as? HttpError
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let params = paramDic else { return }
        let body = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        urlRequest?.httpBody = body
    }
    
    public mutating func setAuthorization(basicToken: String) -> HttpDataRequest {
        let basic = "Basic "
        var token = basicToken
        if token.hasPrefix(basic) {
            let spaceIndex = token.index(of: " ")!
            token = String(token[spaceIndex...])
        }
        
        urlRequest?.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        
        return self
    }
    
    public func go(completion: @escaping (HttpResponse) -> Void) {
        guard error == nil else {
            completion(HttpResponse(error: error))
            return
        }
        
        session.dataTask(with: urlRequest!) { (data, response, error) in
            let httpResponse = HttpResponse(data: data, response: response, error: error)
            completion(httpResponse)
            }.resume()
        
    }
    
}

public struct HttpUploadRequest: HttpRequest {
    
    public let base: String
    public let path: String
    public let session: URLSession
    public var params: [String: Any]?
    
    public var urlRequest: URLRequest?
    public var error: HttpError?
    
    public var base64LoginString: String?
    
    init(base: String, path: String, params: [String: Any]?, session: URLSession) {
        self.base = base
        self.path = path
        self.session = session
    }
    
    public mutating func setAuthorization(basicToken: String) -> HttpUploadRequest {
        let basic = "Basic "
        var token = basicToken
        if token.hasPrefix(basic) {
            let spaceIndex = token.index(of: " ")!
            token = String(token[spaceIndex...])
        }
        
        urlRequest?.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        return self
    }
    
    public func go(completion: @escaping (HttpResponse) -> Void) {
        
    }
    
}

public struct FakeRequest: HttpRequest {
    
    public var base: String
    public var path: String
    public var params: [String: Any]?
    public var method: HttpMethod
    public var type: TaskType
    public var session: URLSession?
    
    public var urlRequest: URLRequest?
    public var error: HttpError?
    
    public var base64LoginString: String?
    
    init(base: String, path: String, params: [String: Any]? = nil, method: HttpMethod, type: TaskType, session: URLSession) {
        self.base = base
        self.path = path
        self.params = params
        self.method = method
        self.type = type
        self.session = session
        
        guard let url = URL(string: base + path) else {
            error = HttpError.invalidURL(base + path)
            return
        }
        
        do {
            let _ = try URLEncording.encord(urlString: base + path, method: .get, paramDic: nil)
        } catch {
            self.error = error as? HttpError
        }
        
        urlRequest = URLRequest(url: url)
    }
    
    public mutating func setAuthorization(basicToken: String) -> FakeRequest {
        let basic = "Basic "
        var token = basicToken
        if token.hasPrefix(basic) {
            let spaceIndex = token.index(of: " ")!
            token = String(token[spaceIndex...])
        }
        
        urlRequest?.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        return self
    }
    
    public func go(completion: @escaping (HttpResponse) -> Void) {
        completion(HttpResponse(fakeRequest: self))
    }
    
}
