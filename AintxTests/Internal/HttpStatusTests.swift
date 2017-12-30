//
//  HttpStatusTests.swift
//  AintxTests
//
//  Created by Matt Tian on 27/12/2017.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import XCTest
@testable import Aintx

class HttpStatusTests: XCTestCase {
    
    var sut: HttpStatus!
    
    func testInit() {
        sut = HttpStatus(code: 100)
        XCTAssertEqual(sut, .continue)
        XCTAssertEqual(sut.description, "100 - Continue")
        
        sut = HttpStatus(code: 101)
        XCTAssertEqual(sut, .switchingProtocols)
        XCTAssertEqual(sut.description, "101 - Switching Protocols")
        
        sut = HttpStatus(code: 200)
        XCTAssertEqual(sut, .ok)
        XCTAssertEqual(sut.description, "200 - OK")
        
        sut = HttpStatus(code: 201)
        XCTAssertEqual(sut, .created)
        XCTAssertEqual(sut.description, "201 - Created")
        
        sut = HttpStatus(code: 202)
        XCTAssertEqual(sut, .accepted)
        XCTAssertEqual(sut.description, "202 - Accepted")
        
        sut = HttpStatus(code: 203)
        XCTAssertEqual(sut, .nonAuthoritativeInformation)
        XCTAssertEqual(sut.description, "203 - Non-Authoritative Information")
        
        sut = HttpStatus(code: 204)
        XCTAssertEqual(sut, .noContent)
        XCTAssertEqual(sut.description, "204 - No Content")
        
        sut = HttpStatus(code: 205)
        XCTAssertEqual(sut, .resetContent)
        XCTAssertEqual(sut.description, "205 - Reset Content")
        
        sut = HttpStatus(code: 206)
        XCTAssertEqual(sut, .partialContent)
        XCTAssertEqual(sut.description, "206 - Partial Content")
        
        sut = HttpStatus(code: 300)
        XCTAssertEqual(sut, .multipleChoices)
        XCTAssertEqual(sut.description, "300 - Multiple Choices")
        
        sut = HttpStatus(code: 301)
        XCTAssertEqual(sut, .movedPermanently)
        XCTAssertEqual(sut.description, "301 - Moved Permanently")
        
        sut = HttpStatus(code: 302)
        XCTAssertEqual(sut, .found)
        XCTAssertEqual(sut.description, "302 - Found")
        
        sut = HttpStatus(code: 303)
        XCTAssertEqual(sut, .seeOther)
        XCTAssertEqual(sut.description, "303 - See Other")
        
        sut = HttpStatus(code: 304)
        XCTAssertEqual(sut, .notModified)
        XCTAssertEqual(sut.description, "304 - Not Modified")
        
        sut = HttpStatus(code: 305)
        XCTAssertEqual(sut, .useProxy)
        XCTAssertEqual(sut.description, "305 - Use Proxy")
        
        sut = HttpStatus(code: 307)
        XCTAssertEqual(sut, .temporaryRedirect)
        XCTAssertEqual(sut.description, "307 - Temporary Redirect")
        
        sut = HttpStatus(code: 400)
        XCTAssertEqual(sut, .badRequest)
        XCTAssertEqual(sut.description, "400 - Bad Request")
        
        sut = HttpStatus(code: 401)
        XCTAssertEqual(sut, .unauthorized)
        XCTAssertEqual(sut.description, "401 - Unauthorized")
        
        sut = HttpStatus(code: 402)
        XCTAssertEqual(sut, .paymentRequired)
        XCTAssertEqual(sut.description, "402 - Payment Required")
        
        sut = HttpStatus(code: 403)
        XCTAssertEqual(sut, .forbidden)
        XCTAssertEqual(sut.description, "403 - Forbidden")
        
        sut = HttpStatus(code: 404)
        XCTAssertEqual(sut, .notFound)
        XCTAssertEqual(sut.description, "404 - Not Found")
        
        sut = HttpStatus(code: 405)
        XCTAssertEqual(sut, .methodNotAllowed)
        XCTAssertEqual(sut.description, "405 - Method Not Allowed")
        
        sut = HttpStatus(code: 406)
        XCTAssertEqual(sut, .notAcceptable)
        XCTAssertEqual(sut.description, "406 - Not Acceptable")
        
        sut = HttpStatus(code: 407)
        XCTAssertEqual(sut, .proxyAuthenticationRequired)
        XCTAssertEqual(sut.description, "407 - Proxy Authentication Required")
        
        sut = HttpStatus(code: 408)
        XCTAssertEqual(sut, .requestTimeout)
        XCTAssertEqual(sut.description, "408 - Request Timeout")
        
        sut = HttpStatus(code: 409)
        XCTAssertEqual(sut, .conflict)
        XCTAssertEqual(sut.description, "409 - Conflict")
        
        sut = HttpStatus(code: 410)
        XCTAssertEqual(sut, .gone)
        XCTAssertEqual(sut.description, "410 - Gone")
        
        sut = HttpStatus(code: 411)
        XCTAssertEqual(sut, .lengthRequired)
        XCTAssertEqual(sut.description, "411 - Length Required")
        
        sut = HttpStatus(code: 412)
        XCTAssertEqual(sut, .preconditionFailed)
        XCTAssertEqual(sut.description, "412 - Precondition Failed")
        
        sut = HttpStatus(code: 413)
        XCTAssertEqual(sut, .requestEntityTooLarge)
        XCTAssertEqual(sut.description, "413 - Request Entity Too Large")
        
        sut = HttpStatus(code: 414)
        XCTAssertEqual(sut, .requestUrlTooLong)
        XCTAssertEqual(sut.description, "414 - Request-URL Too Long")
        
        sut = HttpStatus(code: 415)
        XCTAssertEqual(sut, .unsupportedMediaType)
        XCTAssertEqual(sut.description, "415 - Unsupported Media Type")
        
        sut = HttpStatus(code: 416)
        XCTAssertEqual(sut, .requestedRangeNotSatisfiable)
        XCTAssertEqual(sut.description, "416 - Requested Range Not Satisfiable")
        
        sut = HttpStatus(code: 417)
        XCTAssertEqual(sut, .expectationFailed)
        XCTAssertEqual(sut.description, "417 - Expectation Failed")
        
        sut = HttpStatus(code: 500)
        XCTAssertEqual(sut, .internalServerError)
        XCTAssertEqual(sut.description, "500 - Internal Server Error")
        
        sut = HttpStatus(code: 501)
        XCTAssertEqual(sut, .notImplemented)
        XCTAssertEqual(sut.description, "501 - Not Implemented")
        
        sut = HttpStatus(code: 502)
        XCTAssertEqual(sut, .badGateway)
        XCTAssertEqual(sut.description, "502 - Bad Gateway")
        
        sut = HttpStatus(code: 503)
        XCTAssertEqual(sut, .serviceUnavailable)
        XCTAssertEqual(sut.description, "503 - Service Unavailable")
        
        sut = HttpStatus(code: 504)
        XCTAssertEqual(sut, .gatewayTimeout)
        XCTAssertEqual(sut.description, "504 - Gateway Timeout")
        
        sut = HttpStatus(code: 505)
        XCTAssertEqual(sut, .httpVersionNotSupported)
        XCTAssertEqual(sut.description, "505 - HTTP Version Not Supported")
        
        sut = HttpStatus(code: 999)
        XCTAssertEqual(sut, .unknown)
        XCTAssertEqual(sut.description, "0 - Unknown")
    }
    
    func testIsSuccessful() {
        sut = HttpStatus(code: 199)
        XCTAssertFalse(sut.isSuccessful)

        sut = HttpStatus(code: 200)
        XCTAssert(sut.isSuccessful)
        
        sut = HttpStatus(code: 299)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 300)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 400)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 500)
        XCTAssertFalse(sut.isSuccessful)
    }
    
}
