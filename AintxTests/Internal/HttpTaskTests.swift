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
    
    func testDataTaskForDownload() {
        sut = HttpDataTask(request: request, session: session, taskType: .download, completion: { _ in })
        XCTAssert((sut as! HttpDataTask).sessionTask is URLSessionDownloadTask)
    }
    
    func testDataTaskForUpload() {
        let content = MultipartContent(name: "", fileName: "", contentType: .png, data: Data())
        sut = HttpDataTask(request: request, session: session, taskType: .upload([content]), completion: { _ in })
        XCTAssert((sut as! HttpDataTask).sessionTask is URLSessionUploadTask)
    }
    
    func testFileTaskForDownload() {
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HttpFileTask(request: request, session: session, taskType: .download, progress: progress, completed: completed)
        XCTAssertEqual((sut as! HttpFileTask).taskType, .download)
        XCTAssertNotNil((sut as! HttpFileTask).progress)
        XCTAssertNotNil((sut as! HttpFileTask).completed)
        XCTAssert((sut as! HttpFileTask).sessionTask is URLSessionDownloadTask)
    }
    
    func testFileTaskForUpload() {
        let content = MultipartContent(name: "", fileName: "", contentType: .png, data: Data())
        sut = HttpFileTask(request: request, session: session, taskType: .upload([content]), progress: nil, completed: nil)
        XCTAssert((sut as! HttpFileTask).sessionTask is URLSessionUploadTask)
    }
    
    func testTaskType() {
        let content = MultipartContent(name: "file", fileName: "swift.jpg", contentType: .jpg, data: Data())
        let contents = [content, content]
        
        let data: TaskType = .data
        let download: TaskType = .download
        let upload: TaskType = .upload(contents)
        
        XCTAssertEqual(data, TaskType.data)
        XCTAssertEqual(download, TaskType.download)
        XCTAssertEqual(upload, TaskType.upload(contents))
    }
    
}
