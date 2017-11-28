//
//  HttpError.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    
    case invalidURL(String)
    case encordingFailed(EncordingFailedReason)
    case unsupportedSession(UnsupportedSessionReason)
//    case requestFailed(Error)
    case responseFailed(Error)
    
    public enum EncordingFailedReason {
        case missingParameters(String)
        case invalidParameters(String)
    }
    
    public enum UnsupportedSessionReason {
        case dataInBackground
    }
    
    public enum RequestFailedReason {
        
    }
    
}

extension HttpError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: '\(urlString)'"
        case .encordingFailed(let reason):
            return reason.localizedDescription
        case .unsupportedSession(let reason):
            return reason.localizedDescription
        case .responseFailed(let error):
            return error.localizedDescription
        }
    }
    
}

extension HttpError.EncordingFailedReason: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .missingParameters(let field):
            return "Missing \(field)"
        case .invalidParameters(let field):
            return "Missing \(field)"
        }
    }
    
}

extension HttpError.UnsupportedSessionReason: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .dataInBackground:
            return "Data tasks are not supported in background session"
        }
    }
    
}
