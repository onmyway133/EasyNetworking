//
//  ParameterParser.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

/// Parse parameters
/// Single value: oneValue=bar
/// Array: anArray[]=a&anArrray[]=1
/// Map: aMap[x]=1&aMap[y]=2
/// foo=bar&baz[]=a&baz[]=1&qux[x]=1&qux[y]=2&qux[z]=3
public struct ParameterParser {
    public init() {}
    
    public func parse(parameters: JSONDictionary) -> [(String, String)] {
        var pairs = [(String, String)]()
        parameters.forEach { key, value in
            pairs.append(contentsOf: parse(key: key, value: value))
        }
        
        return pairs
    }
    
    private func parse(key: String, value: Any) -> [(String, String)] {
        var pairs = [(String, String)]()
        
        switch value {
        case let bool as Bool:
            pairs.append(contentsOf: parse(key: key, value: bool ? "1" : "0"))
        case let dictionary as JSONDictionary:
            dictionary.forEach { subKey, subValue in
                pairs.append(contentsOf: parse(key: "\(key)[\(subKey)]", value: subValue))
            }
        case let array as [Any]:
            array.forEach { json in
                pairs.append(contentsOf: parse(key: "\(key)[]", value: json))
            }
        default:
            pairs.append((key, "\(value)"))
        }
        
        return pairs
    }
}
