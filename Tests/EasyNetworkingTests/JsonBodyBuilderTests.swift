//
//  JsonBodyBuilderTests.swift
//  EasyNetworking-Tests
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyNetworking

class JsonBodyBuilderTests: XCTestCase {
    func testBuild() {
        let parameters: [String: Any] = [
            "q": "pokemon",
            "size": 10
        ]
        
        let builder = JsonBodyBuilder(parameters: parameters)
        let body = builder.build()!
        XCTAssertNotNil(body)
        XCTAssertEqual(body.headers["Content-Type"], "application/json")
        
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        XCTAssertEqual(body.body, data)
    }
}
