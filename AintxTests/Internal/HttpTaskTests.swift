//
//  HttpTaskTests.swift
//  AintxTests
//
//  Created by Tong Tian on 06/11/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpTaskTests: XCTestCase {
    
    let urlRequest = URLRequest(url: URL(string: "www.fake.com")!)
    let session = URLSession.shared
    
    func testInit() {
        let sut = HttpDataTask(request: urlRequest, session: session, completion: { _ in })
        
        XCTAssert(sut.sessionTask is URLSessionDataTask)
    }
    
    func testTaskType() {
        let fileURL = URL(string: "www.fake.com")!
        let fileData = "data".data(using: .utf8)!
        
        let data: TaskType = .data
        let fileDownload: TaskType = .file(.download)
        let fileUploadURL: TaskType = .file(.upload(.url(fileURL)))
        let fileUploadData: TaskType = .file(.upload(.data(fileData)))
        
        XCTAssertEqual(data, TaskType.data)
        XCTAssertEqual(fileDownload, TaskType.file(.download))
        XCTAssertEqual(fileUploadURL, TaskType.file(.upload(.url(fileURL))))
        XCTAssertEqual(fileUploadData, TaskType.file(.upload(.data(fileData))))
    }
    
    func testInitWithDownloadTask() {
        let sut = HttpDataTask(request: urlRequest, session: session, taskType: .file(.download), completion: { _ in })
        
        XCTAssert(sut.sessionTask is URLSessionDownloadTask)
    }

    func testInitWithUploadTask() {
        let taskType = TaskType.file(.upload(.data(Data())))
        let sut = HttpDataTask(request: urlRequest, session: session, taskType: taskType, completion: { _ in })
        
        XCTAssert(sut.sessionTask is URLSessionUploadTask)
    }
    
}
