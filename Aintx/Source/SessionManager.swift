//
//  SessionManager.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

protocol SessionManagerProtocol {
    var sessionTasks: [URLSessionTask: HttpTask]? { get set }
    
    func getSession(with config: SessionConfig) -> URLSession
}

class SessionManager: SessionManagerProtocol {
    
    static let shared = SessionManager()
    
    private init() {}
    
    var sessionTasks: [URLSessionTask : HttpTask]?
    
    func getSession(with config: SessionConfig) -> URLSession {
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
