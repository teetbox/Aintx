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

public typealias Parameters = [String: Any]

public struct Aintx {
    
    public let base: String
    public let config: SessionConfig
    
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
    public func go(_ path: String, queryString: [String: String]? = nil, parameters: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, requestType: RequestType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, requestType: RequestType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, requestType: RequestType, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        go(path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters ,completion: completion)
    }
    
    /* ✅ */
    public func go(_ path: String, method: HttpMethod, requestType: RequestType, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil, completion: @escaping (HttpResponse) -> Void) {
        if (isFake) {
            let fakeResponse = HttpResponse(path: path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
            completion(fakeResponse)
            return
        }
        
        let request = createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType)
        request.fire(completion: completion)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, requestType: RequestType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, requestType: RequestType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, requestType: RequestType, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        return createHttpRequest(path: path, method: httpMethod, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters)
    }
    
    /* ✅ */
    public func createHttpRequest(path: String, method: HttpMethod, requestType: RequestType, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) -> HttpRequest {
        let httpRequest: HttpRequest
        
        if (isFake) {
            httpRequest = FakeRequest(base: base, path: path, method: method, requestType: requestType, responseType: responseType, queryString: queryString, parameters: parameters, session: session)
            return httpRequest
        }
        
        switch requestType {
        case .data:
            httpRequest = HttpDataRequest(base: base, path: path, responseType: responseType, queryString: nil, parameters: nil, session: session)
        default:
            httpRequest = HttpDataRequest(base: base, path: path, responseType: responseType, queryString: nil, parameters: nil, session: session)
        }
        
        return httpRequest
    }
    
    /* ✅ */
    public func go(_ request: HttpRequest, completion: @escaping (HttpResponse) -> Void) {
        if (request is FakeRequest) {
            let fakeResponse = HttpResponse(data: nil, response: nil, error: nil)
            completion(fakeResponse)
            return
        }
        
        request.fire(completion: completion)
    }
    
}
