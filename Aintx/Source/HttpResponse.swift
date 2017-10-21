//
//  HttpResponse.swift
//  Aintx
//
//  Created by Tong Tian on 21/10/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

protocol Response {
    var data: Data? { get }
    var response: URLResponse? { get }
    var error: Error? { get }
}

public struct HttpResponse: Response {
    
    public var data: Data?
    public var response: URLResponse?
    public var error: Error?
    
    var json: [String: Any]? {
        return parseJSON()
    }
    
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    // MARK: Fake Response
    
    public var path: String?
    public var httpMethod: HttpMethod?
    public var requestType: RequestType?
    public var responseType: ResponseType?
    public var queryString: [String: String]?
    public var parameters: [String: Any]?
    
    init(path: String, method: HttpMethod, requestType: RequestType, responseType: ResponseType, queryString: Dictionary<String, String>? = nil, parameters: Parameters? = nil) {
        self.path = path
        self.httpMethod = method
        self.requestType = requestType
        self.responseType = responseType
        self.queryString = queryString
        self.parameters = parameters
    }
    
    // MARK: - Methods
    
    private func parseJSON() -> [String: Any]? {
        guard data != nil else { return nil }
        
        if let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] {
            return json
        }
        return nil
    }
    
}

struct DecodableResponse<T: Decodable>: Response {
    
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    var entity: T?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
}
