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
        let urlPath: String
        let urlQueryString: String
        
        if let seperator = path.index(of: "?") {
            urlPath = String(path.prefix(upTo: seperator))
            urlQueryString = String(path.suffix(from: seperator))
        } else {
            urlPath = path
            urlQueryString = ""
        }
        
        guard let encodedPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw URLEncodingError.invalidPath(path)
        }
        
        guard let encodedQuery = urlQueryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLEncodingError.invalidPath(path)
        }
        
        guard let encodedURL = URL(string: base + encodedPath + encodedQuery) else {
            throw URLEncodingError.invalidURL(base + path)
        }

        if case .get = method, let parameters = params {
            let queryString = composeQuery(encoded: encodedQuery, with: parameters)
            guard let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                throw URLEncodingError.invalidParams(parameters)
            }
            
            guard let encodedURL = URL(string: base + encodedPath + encodedQueryString) else {
                throw URLEncodingError.invalidURL(base + path + queryString)
            }
            return encodedURL
        }

        return encodedURL
    }
    
    private static func composeQuery(encoded query: String, with params: [String: Any]) -> String {
        var queryString = query.count > 0 ? query : "?"
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        return queryString
    }
    
}
