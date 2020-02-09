//
//  HttpMethod.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public enum HttpMethod {
    case get
    case post
    case put
    case delete
    case patch
    case head
    case custom(String)
    
    public var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        case .head: return "HEAD"
        case .custom(let string): return string.uppercased()
        }
    }
}
