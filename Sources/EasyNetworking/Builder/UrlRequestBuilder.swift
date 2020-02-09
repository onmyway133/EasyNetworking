//
//  UrloptionsBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public struct UrlRequestBuilder {
    public init() {}
    
    public func build(options: Options, baseUrl: URL) throws -> URLRequest {
        let queryItems = options.queryBuilder.build()

        guard let url = build(baseUrl: baseUrl, path: options.path, queryItems: queryItems) else {
            throw NetworkError.invalidRequest(options)
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = options.httpMethod.rawValue
        request.cachePolicy = options.cachePolicy
        request.allHTTPHeaderFields = options.headers
        
        if let forBody = options.bodyBuilder.build() {
            request.httpBody = forBody.body
            forBody.headers.forEach({ header in
                request.allHTTPHeaderFields?[header.key] = header.value
            })
        }

        return request
    }
    
    public func build(baseUrl: URL, path: String, queryItems: [URLQueryItem]) -> URL? {
        let path = path.starts(with: "/") ? path : "/\(path)"

        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
