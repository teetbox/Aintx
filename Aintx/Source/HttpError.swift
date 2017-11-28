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
    case encordingFailed(EncordingFailedReason)
    case responseFailed(Error)
    
    public enum RequestFailedReason {
        case invalidURL(String)
        case paramsAndBodyDataUsedTogether
        case dataRequestInBackgroundSession
    }
    
    public enum EncordingFailedReason {
        case missingParameters(String)
        case invalidParameters(String)
    }
    
}

extension HttpError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .requestFailed(let reason):
            return reason.localizedDescription
        case .encordingFailed(let reason):
            return reason.localizedDescription
        case .responseFailed(let error):
            return error.localizedDescription
        }
    }
    
}

extension HttpError.RequestFailedReason: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .paramsAndBodyDataUsedTogether:
            return "Params and bodyData should not be used together in dataRequest"
        case .dataRequestInBackgroundSession:
            return "Data tasks are not supported in background session"
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
