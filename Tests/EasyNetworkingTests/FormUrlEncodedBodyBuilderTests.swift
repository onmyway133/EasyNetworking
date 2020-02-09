//
//  FormUrlEncodedBodyBuilderTests.swift
//  EasyNetworking-Tests
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyNetworking

class FormUrlEncodedBodyBuilderTests: XCTestCase {
    func testBuild() {
        let parameters: [String: Any] = [
            "q": "pokemon",
            "size": 10
        ]
        
        let builder = FormUrlEncodedBodyBuilder(parameters: parameters)
        let body = builder.build()!
        XCTAssertNotNil(body)
        XCTAssertEqual(body.headers["Content-Type"], "application/x-www-form-urlencoded")
        
        let data = "q=pokemon&size=10".data(using: .utf8, allowLossyConversion: false)
        XCTAssertEqual(body.body, data)
    }
}
