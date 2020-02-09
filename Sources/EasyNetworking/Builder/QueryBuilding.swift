//
//  QueryBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public protocol QueryBuilding {
    func build() -> [URLQueryItem]
}

public class QueryBuilder: QueryBuilding {
    public let parameters: JSONDictionary

    public init(parameters: JSONDictionary = [:]) {
        self.parameters = parameters
    }

    public func build() -> [URLQueryItem] {
        var components = URLComponents()
        
        let parser = ParameterParser()
        let pairs = parser
            .parse(parameters: parameters)
            .map({ $0 })
            .sorted(by: <)
        
        components.queryItems = pairs.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        
        return components.queryItems ?? []
    }
    
    public func build(queryItems: [URLQueryItem]) -> String {
        var components = URLComponents()
        components.queryItems = queryItems.map({
            return URLQueryItem(name: escape($0.name), value: escape($0.value ?? ""))
        })
        
        return components.query ?? ""
    }
    
    public func escape(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
