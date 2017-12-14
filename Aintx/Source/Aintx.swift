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
    
    public var isFake = false
    public var fakeResponse: HttpResponse?
    
    /* ✅ */
    public init(base: String, config: SessionConfig = .standard) {
        self.base = base
        self.config = config
    }
    
    // MARK: - Methods
    
    /* ✅ */
    @discardableResult
    public func get(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpFakeTask()
        }
        return dataRequest(path: path, method: .get, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func put(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
//            return HttpDataTask()
            fatalError()
        }
        return dataRequest(path: path, method: .put, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
//            return DataTask()
            fatalError()
        }
        return dataRequest(path: path, method: .post, headers: headers, bodyData: nil).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, params: [String: Any]?, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
//            return DataTask()
            fatalError()
        }
        return dataRequest(path: path, method: .post, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, bodyData: Data?, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
//            return DataTask()
            fatalError()
        }
        return dataRequest(path: path, method: .post, headers: headers, bodyData: bodyData).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func delete(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void)-> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
//            return DataTask()
            fatalError()
        }
        return dataRequest(path: path, method: .delete, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    public func dataRequest(path: String, method: HttpMethod = .get, params: [String: Any]? = nil, headers: [String: String]? = nil, bodyData: Data? = nil) -> HttpRequest {
        let request: HttpRequest
        if (isFake) {
            request = FakeRequest(base: base, path: path, method: method, params: params, headers: headers, bodyData: bodyData, sessionConfig: config)
            return request
        }
        
        request = HttpDataRequest(base: base, path: path, method: method, params: params, headers: headers, bodyData: bodyData, sessionConfig: config)
        if case .background(_) = config {
            request.httpError = HttpError.requestFailed(.dataRequestInBackgroundSession)
        }
        
        if params != nil && bodyData != nil {
            request.httpError = HttpError.requestFailed(.paramsAndBodyDataUsedTogether)
        }
        return request
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, fileURL: URL, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpFakeTask()
        }
        
        return uploadRequest(path: path, method: .put, uploadType: .url(fileURL), params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, fileData: Data, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpFakeTask()
        }
        return uploadRequest(path: path, method: .put, uploadType: .data(fileData), params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    public func uploadRequest(path: String, method: HttpMethod = .put, uploadType: UploadType, params: [String: Any]? = nil, headers: [String: String]? = nil) -> HttpRequest {
        let request: HttpRequest
        if (isFake) {
            request = FakeRequest(base: base, path: path, method: method, params: params, headers: headers, uploadType: uploadType, sessionConfig: config)
            return request
        }
        
        request = HttpUploadRequest(base: base, path: path, method: method, uploadType: uploadType, params: params, headers: headers, sessionConfig: config)
        return request
    }
    
    /* ✅ */
    @discardableResult
    public func download(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return HttpFakeTask()
        }
        
        let request = HttpDownloadRequest(base: base, path: path, method: .get, params: params, headers: headers, completion: completion, sessionConfig: config)
        return request.go(completion: completion)
    }
    
    /* ✅ */
    public func downloadRequest(path: String, method: HttpMethod = .get, params: [String: Any]? = nil, headers: [String: String]? = nil, progress: ProgressClosure? = nil, completed: @escaping CompletedClosure) -> HttpLoadRequest {
        let loadRequest: HttpLoadRequest
        
        if (isFake) {
            loadRequest = FakeLoadRequest(base: base, path: path, method: method, params: params, headers: headers, progress: progress, completed: completed, sessionConfig: config)
            return loadRequest
        }

        loadRequest = HttpLoadRequest(base: base, path: path, method: method, params: params, headers: headers, progress: progress, completed: completed, sessionConfig: config)
        return loadRequest
    }
    
}
