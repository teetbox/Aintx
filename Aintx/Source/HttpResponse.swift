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
    var error: Error? { get }
}

public struct HttpResponse: Response {
    
    public var data: Data?
    public var urlResponse: URLResponse?
    public var error: Error?
    
    public var fakeRequest: FakeRequest?
    
    var json: [String: Any]? {
        return parseJSON()
    }
    
    /* ✅ */
    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = response
        self.error = error
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

extension HttpResponse {

    /* ✅ */
    init(fakeRequest: HttpRequest) {
        self.fakeRequest = fakeRequest as? FakeRequest
    }

}

struct DecodableResponse<T: Decodable>: Response {
    
    let data: Data?
    let urlResponse: URLResponse?
    let error: Error?
    
    var entity: T?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = response
        self.error = error
    }
    
}
