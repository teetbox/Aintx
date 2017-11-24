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

let AINTX_SERVER_TOKEN = "AINTX_SERVER_TOKEN"

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
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return dataRequest(path: path, method: .get, params: params).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func put(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return dataRequest(path: path, method: .put, params: params).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return dataRequest(path: path, method: .post, params: nil, bodyData: nil).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, params: [String: Any]?, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return dataRequest(path: path, method: .post, params: params, bodyData: nil).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, bodyData: Data?, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return dataRequest(path: path, method: .post, params: nil, bodyData: bodyData).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func delete(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void)-> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return dataRequest(path: path, method: .delete, params: params).go(completion: completion)
    }
    
    /* ✅ */
    public func dataRequest(path: String, method: HttpMethod = .get, params: [String: Any]? = nil, bodyData: Data? = nil) -> HttpRequest {
        let request: HttpRequest
        if (isFake) {
            request = FakeRequest(base: base, path: path, method: method, params: params, bodyData: bodyData, session: session)
            return request
        }
        
        request = DataRequest(base: base, path: path, method: method, params: params, bodyData: bodyData, session: session)
        if case .background(_) = config {
            request.httpError = HttpError.unsupportedSession(.dataInBackground)
        }
        return request
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, fileURL: URL, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        
        return uploadRequest(path: path, uploadType: .url(fileURL), params: params, method: .put).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, fileData: Data, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return uploadRequest(path: path, uploadType: .data(fileData), params: params, method: .put).go(completion: completion)
    }
    
    /* ✅ */
    public func uploadRequest(path: String, uploadType: UploadType, params: [String: Any]? = nil, method: HttpMethod) -> HttpRequest {
        let request: HttpRequest
        if (isFake) {
            request = FakeRequest(base: base, path: path, method: method, params: params, uploadType: uploadType, session: session)
            return request
        }
        
        request = UploadRequest(base: base, path: path, method: method, uploadType: uploadType, params: params, session: session)
        return request
    }
    
    /* ✅ */
    @discardableResult
    public func download(_ path: String, params: [String: Any]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpTask(sessionTask: URLSessionTask())
        }
        return downloadRequest(path, params: params, method: .get).go(completion: completion)
    }
    
    /* ✅ */
    public func downloadRequest(_ path: String, params: [String: Any]? = nil, method: HttpMethod) -> HttpRequest {
        let request: HttpRequest
        if (isFake) {
            request = FakeRequest(base: base, path: path, method: method, params: params, session: session)
            return request
        }
        
        request = DownloadRequest(base: base, path: path, params: params, method: method, session: session)
        return request
    }
    
    /* ✅ */
    public func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: AINTX_SERVER_TOKEN)
    }
    
    /* ✅ */
    public func removeToken() {
        UserDefaults.standard.set(nil, forKey: AINTX_SERVER_TOKEN)
    }
    
}
