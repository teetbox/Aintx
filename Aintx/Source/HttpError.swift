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
    
    public enum EncordingFailedReason {
        case missingParameters(String)
        case invalidParameters(String)
    }
    
}
