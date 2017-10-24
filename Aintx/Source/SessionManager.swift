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
        
        let session: URLSession
        switch config {
        case .standard:
            session = URLSession.shared
        case .ephemeral:
            session = URLSession(configuration: .ephemeral)
        case .background(let identifier):
            session = URLSession(configuration: .background(withIdentifier: identifier))
        }
        
        return session
    }
    
}
