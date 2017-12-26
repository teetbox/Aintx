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
    
    private var standard: URLSession?
    private var ephemeral: URLSession?
    private var background: URLSession?

    private var sessionTasks = [URLSessionTask: HttpFileTask]()
    private var requestGroup = [HttpFileTask: HttpRequestGroup]()
    
    private override init() {}
    
    /* ✅ */
    subscript(sessionTask: URLSessionTask) -> HttpFileTask? {
        set {
            sessionTasks[sessionTask] = newValue
        }
        get {
            return sessionTasks[sessionTask]
        }
    }
    
    /* ✅ */
    subscript(fileTask: HttpFileTask) -> HttpRequestGroup? {
        set {
            requestGroup[fileTask] = newValue
        }
        get {
            return requestGroup[fileTask]
        }
    }
    
    /* ✅ */
    func getSession(with config: SessionConfig) -> URLSession {
        switch config {
        case .standard:
            if standard == nil {
                standard = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            }
            return standard!
        case .ephemeral:
            if ephemeral == nil {
                ephemeral = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
            }
            return ephemeral!
        case .background(let identifier):
            if (background == nil || background!.configuration.identifier != identifier) {
                background = URLSession(configuration: .background(withIdentifier: identifier), delegate: self, delegateQueue: nil)
            }
            return background!
        }
    }
    
    /* ✅ */
    func reset() {
        standard = nil
        ephemeral = nil
        background = nil
    }
    
}

extension SessionManager: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    // URLSessionDelegate
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("###### URLSessionDelegate - didBecomeInvalidWithError ######")
        print(#function)
    }
    
    /* Not ready for authentication
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("###### URLSessionDelegate - didReceive, completionHandler ######")
        print(#function)
    }
    */
    
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

    /* Not ready for authentication
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("###### URLSessionTaskDelegate - didReceive, completionHandler ######")
        print(#function)
    }
    */
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        print("###### URLSessionTaskDelegate - needNewBodyStream ######")
        print(#function)
    }
    
    /* No need
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("###### URLSessionTaskDelegate - didSendBodyData, totalBytesSent, totalBytesExpectedToSend ######")
        print(#function)
    }
    */
    
    /* No need
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("###### URLSessionTaskDelegate - didFinishCollecting ######")
        print(#function)
    }
    */
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("###### URLSessionTaskDelegate - didCompleteWithError ######")
        print(#function)
        guard error != nil else { return }
        if let fileTask = sessionTasks[task] {
            fileTask.completed?(nil, error)
            if let group = requestGroup[fileTask] {
                group.nextTask()
            }
        }
    }
    
    // URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("###### URLSessionDataDelegate - didReceive, completionHandler ######")
        print(#function)
        let httpURLResponse = (response as? HTTPURLResponse)?.statusCode
        print(httpURLResponse ?? 000)
        print(response)
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
        if let fileTask = sessionTasks[downloadTask] {
            fileTask.progress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("###### URLSessionDownloadDelegate - didFinishDownloadingTo ######")
        print(#function)
        if let fileTask = sessionTasks[downloadTask] {
            fileTask.completed?(location, nil)
            if let group = requestGroup[fileTask] {
                group.nextTask()
            }
        }
    }
    
}
