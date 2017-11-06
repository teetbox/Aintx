//
//  RequestToken.swift
//  Aintx
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public struct RequestToken {
    
    let task: URLSessionTask
    
    public func suspend() {
        task.suspend()
    }
    
    public func resume() {
        task.resume()
    }
    
    public func cancel() {
        task.cancel()
    }
    
}
