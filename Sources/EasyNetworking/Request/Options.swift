//
//  Request.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public struct Options {
    public var path: String = ""
    public var queryBuilder: QueryBuilding = QueryBuilder()
    public var bodyBuilder: BodyBuilding = EmptyBodyBuilder()
    public var headers: [String: String] = [:]
    public var httpMethod: HttpMethod = .get
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    public init() {}
}
