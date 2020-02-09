//
//  MultipartFormBodyBuilderTests.swift
//  EasyNetworking-Tests
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyNetworking

class MultipartFormBodyBuilderTests: XCTestCase {
    func testBuild() {
        let parameters: [String: Any] = [
            "q": "pokemon",
            "size": 10
        ]
        
        let builder = MultipartFormBodyBuilder(parameters: parameters)
        let body = builder.build()!
        XCTAssertNotNil(body)
        XCTAssertEqual(body.headers["Content-Type"], "multipart/form-data; boundary=EasyNetworking")
        
        let expectedString =
"""
--EasyNetworking
Content-Disposition: form-data; name="q"

pokemon
--EasyNetworking
Content-Disposition: form-data; name="size"

10
--EasyNetworking--

"""
        
        let string = builder.string(parameters: parameters)
        XCTAssertEqual(string.count, expectedString.count)
    }
}
