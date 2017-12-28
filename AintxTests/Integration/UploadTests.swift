//
//  UploadTests.swift
//  AintxTests
//
//  Created by Matt Tian on 22/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
import Aintx

extension UIColor {
    func getImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image(actions: { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        })
    }
}

class UploadTests: XCTestCase {
    
    var sut: Aintx!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        sut = Aintx(base: "")
        async = expectation(description: "async")
    }
    
    func testUploadFromURL() {
        let path = "http://127.0.0.1:8000/upload"
        let fileURL = URL(string: "/Users/matt/Desktop/swift.jpg")!
        let content = MultiPartContent(name: "file", type: .jpg, url: fileURL)
        
        sut.upload(path, content: content) { response in
            let httpResponse = response.urlResponse as? HTTPURLResponse
            let code = httpResponse?.statusCode

            XCTAssertNil(response.error)
            XCTAssertEqual(code, 200)
            let dataString = String(data: response.data ?? Data(), encoding: .utf8)
            print("Data: \(dataString ?? "is blank")")

            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 20)
    }
    
    func testUploadWithData() {
        let path = "https://efbplus.ceair.com:600/hwappcms/etp/fileUpload/uploadIcon"
        let params = ["userNo": "test1234"]
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        let content = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: imageData)
        
        sut.upload(path, content: content, params: params) { response in
            let urlResponse = response.urlResponse as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            XCTAssertEqual(statusCode, 200)
            let json = response.json! as [String: Any]
            XCTAssertEqual(json["success"] as! Int, 1)
            print(json)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 50)
    }
    
    func testFileRequestForUpload() {
        let path = "https://efbplus.ceair.com:600/hwappcms/etp/fileUpload/uploadIcon"
        let params = ["userNo": "test1234"]
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        let content = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: imageData)
        
        let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Uploading file \(String(format: "%.2f", percentage))%")
        }
        
        sut.fileRequest(uploadPath: path, method: .post, content: content, params: params, progress: progress) { _, error in
            XCTAssertNil(error)
            self.async.fulfill()
        }.go()
        
        wait(for: [async], timeout: 50)
    }
    
    func testRequestGroupForUpload() {
        let path = "https://efbplus.ceair.com:600/hwappcms/etp/fileUpload/uploadIcon"
        let params = ["userNo": "test1234"]
        
        guard let image = UIImage(contentsOfFile: "/Users/matt/Desktop/swift.jpg") else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        let content = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: imageData)
        
        let progress: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Uploading file 1 \(String(format: "%.2f", percentage))%")
        }
        
        let completed: CompletedClosure = { url, error in
            print("Uploading file 1 Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Uploading file 1 Completed with error: - \(error?.localizedDescription ?? "nil")")
        }
        
        let progress2: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Uploading file 2 \(String(format: "%.2f", percentage))%")
        }
        
        let completed2: CompletedClosure = { url, error in
            print("Uploading file 2 Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Uploading file 2 Completed with error: - \(error?.localizedDescription ?? "nil")")
        }
        
        let progress3: ProgressClosure = { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            print("Uploading file 3 \(String(format: "%.2f", percentage))%")
        }
        
        let completed3: CompletedClosure = { url, error in
            print("Uploading file 3 Completed with url: - \(url?.absoluteString ?? "nil")")
            print("Uploading file 3 Completed with error: - \(error?.localizedDescription ?? "nil")")
            self.async.fulfill()
        }
        
        let request = sut.fileRequest(uploadPath: path, content: content, params: params, progress: progress, completed: completed)
        let request2 = sut.fileRequest(uploadPath: path, content: content, params: params, progress: progress2, completed: completed2)
        let request3 = sut.fileRequest(uploadPath: path, content: content, params: params, progress: progress3, completed: completed3)
        
        let tasks = (request --> request2 --> request3).go()
        
        XCTAssertEqual(tasks.count, 3)
        wait(for: [async], timeout: 200)
    }
    
}
