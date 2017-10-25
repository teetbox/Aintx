//
//  URLEncording.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

struct URLEncording {
    
    static func encordQueryString(path: String, queryDic: [String: String]?) throws -> String {
        guard let query = queryDic else {
            return path
        }
        
        var url = path + "?"
        for (key, value) in query {
            url += "\(key)=\(value)&"
        }
        return url
    }
    
    static func encord(urlString: String, method: HttpMethod, paramDic: Dictionary<String, Any>?) throws -> URL {
        if let url = composeURL(urlString: urlString, method: method, paramDic: paramDic) {
            return url
        } else {
//            throw NetworkError.requestError(.invaliedURL(urlString))
            return URL(string: "fakeURL")!
        }
    }
    
    private static func composeURL(urlString: String, method: HttpMethod, paramDic: Dictionary<String, Any>?) -> URL? {
        guard method == .get, let params = paramDic else {
//            return URL(string: URLS.Domain + urlString)
            return nil
        }
        var url = urlString
        url += queryString(with: params)
        return URL(string: url)
    }
    
    private static func queryString(with params: Dictionary<String, Any>) -> String {
        var queryString = "?"
        
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        
        return queryString
    }
    
}
