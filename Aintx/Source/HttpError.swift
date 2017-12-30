//
//  HttpError.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    case requestError(HttpRequestError)
    case encodingError(URLEncodingError)
    case statusError(HttpStatus)
    case responseError(Error)
}

public enum HttpRequestError {
    case paramsAndBodyDataUsedTogether(String)
    case dataRequestInBackgroundSession
    case emptyURLRequest
}

public enum URLEncodingError: Error {
    case invalidURL(String)
    case invalidPath(String)
    case invalidParams([String: Any])
}

extension HttpError: LocalizedError, CustomStringConvertible {
    
    public var localizedDescription: String {
        switch self {
        case .requestError(let error):
            return error.localizedDescription
        case .encodingError(let error):
            return error.localizedDescription
        case .responseError(let error):
            return error.localizedDescription
        case .statusError(let statusCode):
            return "HTTP status code: \(statusCode)"
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
}

extension HttpRequestError: LocalizedError, CustomStringConvertible {
    
    public var localizedDescription: String {
        switch self {
        case .paramsAndBodyDataUsedTogether(let method):
            return "Params and bodyData should not be used together in \(method) request"
        case .dataRequestInBackgroundSession:
            return "Data request can't run in background session"
        case .emptyURLRequest:
            return "URLRequest is nil"
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
}

extension URLEncodingError: LocalizedError, CustomStringConvertible {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid url: \(urlString)"
        case .invalidPath(let path):
            return "Invalid path: \(path)"
        case .invalidParams(let params):
            return "Invalid params: \(params)"
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
}
