//
//  URLEncording.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

struct URLEncording {
    
    static func composeURLString(base: String, path: String, params: [String: Any]? = nil) throws -> String {
        var urlString = base + path
        if let params = params {
            urlString += queryString(with: params)
        }
        return urlString
    }
    
    static func encord(base: String, path: String) throws -> URL {
        guard let url = URL(string: base + path) else {
            throw HttpError.invalidURL(base + path)
        }
        
        return url
    }
    
    static func encord(urlString: String, method: HttpMethod, params: [String: Any]?) throws -> URL {
        if let url = composeURL(urlString: urlString, method: method, params: params) {
            return url
        } else {
            throw HttpError.invalidURL(urlString)
        }
    }
    
    private static func composeURL(urlString: String, method: HttpMethod, params: [String: Any]?) -> URL? {
        guard method == .get, let params = params else {
            return nil
        }
        var url = urlString
        url += queryString(with: params)
        return URL(string: url)
    }
    
    private static func queryString(with params: [String: Any]) -> String {
        var queryString = "?"
        
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        
        return queryString
    }
    
}
