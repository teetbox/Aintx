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
    var urlResponse: URLResponse? { get }
    var error: HttpError? { get }
}

public struct HttpResponse: Response {
    
    public var data: Data?
    public var urlResponse: URLResponse?
    public var error: HttpError?
    
    var fakeRequest: FakeDataRequest?
    
    public var json: [String: Any]? {
        return parseJSON()
    }
    
    public var jsonArray: [Any]? {
        return parseJSONArray()
    }
    
    /* ✅ */
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = response
        self.error = (error == nil) ? nil : error as? HttpError ?? HttpError.responseFailed(error!)
    }
    
    // MARK: - Methods
    
    private func parseJSON() -> [String: Any]? {
        guard data != nil else { return nil }
        
        if let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] {
            return json
        }
        return nil
    }
    
    private func parseJSONArray() -> [Any]? {
        guard data != nil else { return nil }
        
        if let jsonArray = try? JSONSerialization.jsonObject(with: data!) as? [Any] {
            return jsonArray
        }
        return nil
    }
    
}

extension HttpResponse {

    init(fakeRequest: HttpRequest) {
        self.fakeRequest = fakeRequest as? FakeDataRequest
    }

}

struct DecodableResponse<T: Decodable>: Response {
    
    let data: Data?
    let urlResponse: URLResponse?
    let error: HttpError?
    
    var entity: T?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = response
        self.error = (error == nil) ? nil : error as? HttpError ?? HttpError.responseFailed(error!)
    }
    
}
