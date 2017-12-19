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
    
    var sut: HttpTask!
    
    let request = URLRequest(url: URL(string: "www.fake.com")!)
    let session = URLSession.shared

    let fileURL = URL(string: "www.fake.com")!
    let fileData = "data".data(using: .utf8)!
    
    override func setUp() {
        sut = HttpDataTask(request: request, session: session, completion: { _ in })
    }
    
    func testDataTask() {
        let dataTask = sut as! HttpDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDataTask)
    }
    
    func testDataTaskForDownloadType() {
        sut = HttpDataTask(request: request, session: session, taskType: .file(.download), completion: { _ in })
        XCTAssert((sut as! HttpDataTask).sessionTask is URLSessionDownloadTask)
    }
    
    func testFileTask() {
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HttpFileTask(request: request, session: session, taskType: .file(.download), progress: progress, completed: completed)
        XCTAssertEqual((sut as! HttpFileTask).taskType, .file(.download))
        XCTAssertNotNil((sut as! HttpFileTask).progress)
        XCTAssertNotNil((sut as! HttpFileTask).completed)
        XCTAssert((sut as! HttpFileTask).sessionTask is URLSessionDownloadTask)
    }
    
    func testTaskType() {
        let data: TaskType = .data
        let fileDownload: TaskType = .file(.download)
        let fileUploadURL: TaskType = .file(.upload(.url(fileURL)))
        let fileUploadData: TaskType = .file(.upload(.data(fileData)))
        
        XCTAssertEqual(data, TaskType.data)
        XCTAssertEqual(fileDownload, TaskType.file(.download))
        XCTAssertEqual(fileUploadURL, TaskType.file(.upload(.url(fileURL))))
        XCTAssertEqual(fileUploadData, TaskType.file(.upload(.data(fileData))))
    }
    
}
