//
//  MultipartContent.swift
//  Aintx
//
//  Created by Matt Tian on 27/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

public enum ContentType {
    case data
    case jpg
    case png
    
    var rawValue: String {
        switch self {
        case .data:
            return "application/octet-stream"
        case .jpg:
            return "image/jpeg"
        case .png:
            return "image/png"
        }
    }
}

public struct MultipartContent {
    
    let name: String
    let fileName: String
    let contentType: String
    let data: Data
    
    public init(name: String, fileName: String, contentType: ContentType, data: Data) {
        self.name = name
        self.fileName = fileName
        self.contentType = contentType.rawValue
        self.data = data
    }
    
}
