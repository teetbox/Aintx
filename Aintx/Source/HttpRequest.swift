//
//  HttpRequest.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public protocol HttpRequest {
    var responseType: ResponseType { get set }
    var urlRequest: URLRequest? { get set }
    var error: HttpError? { get set  }
    
    func go(completion: @escaping (HttpResponse) -> Void)
    
    mutating func setAuthorization(_ identifier: String)
}

extension HttpRequest {
    
    public var authToken: String? {
        get {
            return urlRequest?.value(forHTTPHeaderField: "Authorization")}
        set {
            urlRequest?.setValue(newValue, forHTTPHeaderField: "Authorization")
        }
    }
    
    public var basicAuth: String? {
        return nil
    }
    
    public mutating func setAuthorization(_ identifier: String) {
        urlRequest?.setValue(identifier, forHTTPHeaderField: "Authorization")
    }
    
}

public struct HttpDataRequest: HttpRequest {
    
    public let base: String
    public let path: String
    public let session: URLSession
    public var responseType: ResponseType
    
    public var queryDic: Dictionary<String, String>?
    public var paramDic: Dictionary<String, Any>?
    
    public var urlRequest: URLRequest?
    public var error: HttpError?
    
    init(base: String, path: String, responseType: ResponseType = .json, queryDic: Dictionary<String, String>?, paramDic: Dictionary<String, Any>?, session: URLSession) {
        self.base = base
        self.path = path
        self.session = session
        self.responseType = responseType
        
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
        urlRequest?.httpMethod = "GET"
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
    public var responseType: ResponseType
    
    public var queryDic: Dictionary<String, String>?
    public var paramDic: Dictionary<String, Any>?
    
    public var urlRequest: URLRequest?
    public var error: HttpError?
    
    init(base: String, path: String, responseType: ResponseType = .json, queryDic: Dictionary<String, String>?, paramDic: Dictionary<String, Any>?, session: URLSession) {
        self.base = base
        self.path = path
        self.session = session
        self.responseType = responseType
    }
    
    public func go(completion: @escaping (HttpResponse) -> Void) {
        
    }
    
}

public struct FakeRequest: HttpRequest {
    
    public var base: String
    public var path: String
    public var httpMethod: HttpMethod
    public var requestType: RequestType
    public var responseType: ResponseType
    public var queryDic: Dictionary<String, String>?
    public var paramDic: Dictionary<String, Any>?
    public var session: URLSession?
    
    public var urlRequest: URLRequest?
    public var error: HttpError?
    
    init(base: String, path: String, method: HttpMethod, requestType: RequestType, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, session: URLSession) {
        self.base = base
        self.path = path
        self.httpMethod = method
        self.requestType = requestType
        self.responseType = responseType
        self.queryDic = queryDic
        self.paramDic = paramDic
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
    
    public func go(completion: @escaping (HttpResponse) -> Void) {
        completion(HttpResponse(fakeRequest: self))
    }
    
}
