//
//  UrlRequestBuilderTests.swift
//  EasyNetworking-Tests
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyNetworking

class UrlRequestBuilderTests: XCTestCase {
    let parameters: JSONDictionary = [
        "oneValue": "bar",
        "anArray": ["a", 1],
        "aMap": [
            "x": 1,
            "y": 2,
            "z": 3
        ]
    ]

    func testParser() {
        let parser = ParameterParser()
        let pairs = parser.parse(parameters: parameters)
        XCTAssertEqual(pairs.count, 6)
        XCTAssertTrue(pairs.contains(where: { $0.0 == "aMap[x]" }))
        XCTAssertTrue(pairs.contains(where: { $0.0 == "aMap[y]" }))
        XCTAssertTrue(pairs.contains(where: { $0.0 == "aMap[z]" }))
        XCTAssertTrue(pairs.contains(where: { $0.0 == "anArray[]" }))
    }
    
    func testQuery() throws {
        let builder = QueryBuilder(parameters: parameters)
        let queryItems = builder.build()
        let query = builder.build(queryItems: queryItems)
        
        XCTAssertTrue(query.contains("oneValue=bar"))
        XCTAssertTrue(query.contains("aMap%5Bx%5D=1"))
        XCTAssertTrue(query.contains("aMap%5By%5D=2"))
        XCTAssertTrue(query.contains("aMap%5Bz%5D=3"))
        XCTAssertTrue(query.contains("anArray%5B%5D=1"))
        XCTAssertTrue(query.contains("anArray%5B%5D=a"))
    }
    
    func testUrl() {
        let builder = UrlRequestBuilder()
        let queryItem = URLQueryItem(name: "q", value: "pokemon")
        let url = builder.build(baseUrl: URL(string: "https://google.com/")!, path: "/abc", queryItems: [queryItem])
        XCTAssertEqual(url, URL(string: "https://google.com/abc?q=pokemon")!)
    }
    
    func testUrl2() {
        let builder = UrlRequestBuilder()
        let queryItem = URLQueryItem(name: "q", value: "pokemon")
        let url = builder.build(baseUrl: URL(string: "https://google.com")!, path: "abc", queryItems: [queryItem])
        XCTAssertEqual(url, URL(string: "https://google.com/abc?q=pokemon")!)
    }
    
    func testRequest() throws {
        var options = Options()
        options.httpMethod = .patch
        options.path = "search"
        options.queryBuilder = QueryBuilder(parameters: [
            "q": "pokemon",
            "size": "10"
        ])

        options.headers = [
            "My-Header": "My-Header-Value"
        ]
        
        options.cachePolicy = .reloadIgnoringCacheData
        
        let builder = UrlRequestBuilder()
        let request = try builder.build(options: options, baseUrl: URL(string: "https://google.com")!)
        XCTAssertEqual(request.httpMethod, "PATCH")
        XCTAssertEqual(request.cachePolicy, .reloadIgnoringCacheData)
        XCTAssertEqual(request.allHTTPHeaderFields?.count, 1)
        XCTAssertEqual(request.allHTTPHeaderFields?["My-Header"], "My-Header-Value")
        XCTAssertEqual(request.url, URL(string: "https://google.com/search?q=pokemon&size=10"))
    }
}
