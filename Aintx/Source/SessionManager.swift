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

class SessionDownloadDelegate: NSObject, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

    }
   
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

    }
    
}
