//
//  SessionManager.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

struct SessionManager {
    
    static func getSession(with config: SessionConfig) -> URLSession {
        _ = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        switch config {
        case .default:
            return URLSession.shared
        case .ephemeral:
            return URLSession(configuration: .ephemeral)
        case .background(let identifier):
            return URLSession(configuration: .background(withIdentifier: identifier))
        }
    }
    
}
