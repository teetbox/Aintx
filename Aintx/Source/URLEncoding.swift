//
//  URLEncoding.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

struct URLEncoding {
    
    static func encord(base: String, path: String, method: HttpMethod, params: [String: Any]?) throws -> URL {
        guard let encodedBase = base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLEncodingError.invalidBase(base)
        }
        
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw URLEncodingError.invalidPath(path)
        }
        
        guard let encodedURL = URL(string: encodedBase + encodedPath) else {
            throw URLEncodingError.invalidURL(base + path)
        }

        if case .get = method, let parameters = params {
            let queryString = composeQuery(with: parameters)
            guard let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                throw URLEncodingError.invalidParams(parameters)
            }
            
            guard let encodedURL = URL(string: encodedBase + encodedPath + encodedQueryString) else {
                throw URLEncodingError.invalidURL(base + path + queryString)
            }
            return encodedURL
        }

        return encodedURL
    }
    
    private static func composeQuery(with params: [String: Any]) -> String {
        var queryString = "?"
        
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        
        return queryString
    }
    
}
