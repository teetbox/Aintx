//
//  SessionManager.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

class SessionManager: NSObject {
    
    static let shared = SessionManager()
    
    var tasks = [URLSessionTask: HttpTask]()

    private override init() {}
    
    func getSession(with config: SessionConfig) -> URLSession {
        let session: URLSession
        
        switch config {
        case .standard:
            session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        case .ephemeral:
            session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        case .background(let identifier):
            session = URLSession(configuration: .background(withIdentifier: identifier), delegate: self, delegateQueue: nil)
        }
        
        return session
    }
    
}

extension SessionManager: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    // URLSessionDelegate
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("###### URLSessionDelegate - didBecomeInvalidWithError ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("###### URLSessionDelegate - didReceive, completionHandler ######")
        print(#function)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("###### URLSessionDelegate - session ######")
        print(#function)
    }
    
    // URLSessionTaskDelegate
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        print("###### URLSessionTaskDelegate - willBeginDelayedRequest, completionHandler ######")
        print(#function)
    }
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("###### URLSessionTaskDelegate - taskIsWaitingForConnectivity ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        print("###### URLSessionTaskDelegate - willPerformHTTPRedirection, newRequest, completionHandler ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("###### URLSessionTaskDelegate - didReceive, completionHandler ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        print("###### URLSessionTaskDelegate - needNewBodyStream ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("###### URLSessionTaskDelegate - didSendBodyData, totalBytesSent, totalBytesExpectedToSend ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("###### URLSessionTaskDelegate - didFinishCollecting ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("###### URLSessionTaskDelegate - didCompleteWithError ######")
        print(#function)
    }
    
    // URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("###### URLSessionDataDelegate - didReceive, completionHandler ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        print("###### URLSessionDataDelegate - didBecome downloadTask ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        print("###### URLSessionDataDelegate - didBecome streamTask ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("###### URLSessionDataDelegate - didReceive data ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("###### URLSessionDataDelegate - willCacheResponse, completionHandler ######")
        print(#function)
    }
    
    // URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("###### URLSessionDownloadDelegate - didResumeAtOffset, expectedTotalBytes ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("###### URLSessionDownloadDelegate - didWriteData, totalBytesWritten, totalBytesExpectedToWrite ######")
        print(#function)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("###### URLSessionDownloadDelegate - didFinishDownloadingTo ######")
        print(#function)
    }
    
}
