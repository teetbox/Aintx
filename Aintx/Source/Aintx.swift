//
//  Aintx.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public enum SessionConfig {
    case standard
    case ephemeral
    case background(String)
}

public enum HttpMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

public enum RequestType {
    case data
    case downLoad
    case upload
    case stream
}

public enum ResponseType {
    case json
    case data
    case image
    case stream
}

public struct Aintx {
    
    let base: String
    let config: SessionConfig
    let session: URLSession
    
    public var httpMethod: HttpMethod = .get
    public var requestType: RequestType = .data
    public var responseType: ResponseType = .json
    
    public var isFake = false
    public var fakeResponse: HttpResponse?
    
    /* ✅ */
    public init(base: String, config: SessionConfig = .standard) {
        self.base = base
        self.config = config
        self.session = SessionManager.getSession(with: config)
    }
    
    // MARK: - Methods
    
    /* ✅ */
    public func go(_ path: String, queryDic: [String: String]? = nil, paramDic: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, requestType: RequestType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, requestType: RequestType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, requestType: RequestType, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, requestType: RequestType, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil, completion: @escaping (HttpResponse) -> Void) {
        let httpRequest = createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
        if (isFake) {
            let httpResponse = HttpResponse(fakeRequest: httpRequest)
            completion(httpResponse)
            return
        }
        httpRequest.go(completion: completion)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, requestType: RequestType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, requestType: RequestType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, requestType: RequestType, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, requestType: RequestType, responseType: ResponseType, queryDic: Dictionary<String, String>? = nil, paramDic: Dictionary<String, Any>? = nil) -> HttpRequest {
        let httpRequest: HttpRequest
        
        if (isFake) {
            httpRequest = FakeRequest(base: base, path: path, method: method, requestType: requestType, responseType: responseType, queryDic: queryDic, paramDic: paramDic, session: session)
            return httpRequest
        }
        
        switch requestType {
        case .data:
            httpRequest = HttpDataRequest(base: base, path: path, method: method, responseType: responseType, queryDic: nil, paramDic: nil, session: session)
        default:
            httpRequest = HttpDataRequest(base: base, path: path, method: method, responseType: responseType, queryDic: nil, paramDic: nil, session: session)
        }
        
        return httpRequest
    }
    
    /* ✅ */
    public func go(_ httpRequest: HttpRequest, completion: @escaping (HttpResponse) -> Void) {
        if (httpRequest is FakeRequest) {
            let fakeResponse = HttpResponse(fakeRequest: httpRequest)
            completion(fakeResponse)
            return
        }
        
        httpRequest.go(completion: completion)
    }
    
}
