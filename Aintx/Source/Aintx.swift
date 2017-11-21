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
    case head = "HEAD"
    case delete = "DELETE"
}

public enum UploadType {
    case url(URL)
    case data(Data)
}

public struct Aintx {
    
    let base: String
    let config: SessionConfig
    let session: URLSession
    
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
    @discardableResult
    public func get(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        return go(path, params: params, method: .get, completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func put(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        return go(path, params: params, method: .put, completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        return go(path, params: params, method: .post, completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func delete(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void)-> HttpTask {
        return go(path, params: params, method: .delete, completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, fileURL: URL, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        return go(path, uploadType: .url(fileURL), completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, fileData: Data, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        return go(path, uploadType: .data(fileData), completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func download(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        return HttpTask(sessionTask: URLSessionTask())
    }
    
    /* ✅ */
    public func dataRequest(path: String, params: [String: Any]? = nil, method: HttpMethod = .get) -> HttpRequest {
        let request: HttpRequest
        
        if (isFake) {
            request = FakeRequest(base: base, path: path, params: params, method: method, session: session)
            return request
        }
        
        request = DataRequest(base: base, path: path, params: params, method: method, session: session)
        
        if case .background(_) = config {
            request.httpError = HttpError.unsupportedSession(.dataInBackground)
        }
        
        return request
    }
    
    public func uploadRequest(path: String, type: UploadType, params: [String: Any]? = nil, method: HttpMethod) -> HttpRequest {
        let request: HttpRequest
        
        if (isFake) {
            request = FakeRequest(base: base, path: path, params: params, method: method, session: session)
            return request
        }
        
        request = UploadRequest(base: base, path: path, type: type, params: params, method: method, session: session)
        return request
    }
    
    private func go(_ path: String, params: [String: Any]? = nil, method: HttpMethod, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        let request = dataRequest(path: path, params: params, method: method)
        if (isFake) {
            let response = fakeResponse ?? HttpResponse(fakeRequest: request)
            completion(response)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return request.go(completion: completion)
    }
    
    private func go(_ path: String, uploadType: UploadType, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        let request = uploadRequest(path: path, type: uploadType, method: .put)
        
        return request.go(completion: completion)
    }
    
}
