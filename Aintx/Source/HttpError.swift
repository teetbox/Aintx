//
//  HttpError.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public enum HttpError: Error {

    case requestFailed(RequestFailedReason)
    case encodingFailed(URLEncodingError)
    case responseError(Error)
    case statusCodeError(HttpStatus)
    
    public enum RequestFailedReason {
        case paramsAndBodyDataUsedTogether
        case dataRequestInBackgroundSession
    }
    
}

public enum URLEncodingError: Error {
    case invalidURL(String)
    case invalidPath(String)
    case invalidParams([String: Any])
}

extension HttpError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .requestFailed(let reason):
            return reason.localizedDescription
        case .encodingFailed(let error):
            return error.localizedDescription
        case .responseError(let error):
            return error.localizedDescription
        case .statusCodeError(let statusCode):
            return "HTTP status code: \(statusCode.rawValue) - " + statusCode.description
        }
    }
    
}

extension URLEncodingError: LocalizedError {
    
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
    
}

extension HttpError.RequestFailedReason: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .paramsAndBodyDataUsedTogether:
            return "Params and bodyData should not be used together in dataRequest"
        case .dataRequestInBackgroundSession:
            return "Data request can't run in background session"
        }
    }
    
}
