//
//  HttpTask.swift
//  Aintx
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public struct HttpTask {
    
    let sessionTask: URLSessionTask
    
    public func suspend() {
        sessionTask.suspend()
    }
    
    public func resume() {
        sessionTask.resume()
    }
    
    public func cancel() {
        sessionTask.cancel()
    }
    
}
