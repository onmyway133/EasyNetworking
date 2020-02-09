//
//  Miami.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary] 

public extension DispatchQueue {
    static func serial() -> DispatchQueue {
        return DispatchQueue(label: "Miami")
    }
}

public struct Sequence<T> {
    public let values: [T]
}

public struct Response {
    let data: Data
    let urlResponse: URLResponse
    
    public init(data: Data, urlResponse: URLResponse) {
        self.data = data
        self.urlResponse = urlResponse
    }
}
