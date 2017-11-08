//
//  HttpError.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

enum HttpError: Error {
    
    case invalidURL(String)
    case encordingFailed(EncordingFailedReason)
    
    enum EncordingFailedReason {
        case missingParameters(String)
        case invalidParameters(String)
    }
    
}

extension HttpError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: '\(urlString)'"
        default:
            return "Http Error"
        }
    }
}
