//
//  JsonBodyBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class JsonBodyBuilder: BodyBuilder {
    public let parameters: JSONDictionary
    
    public init(parameters: JSONDictionary) {
        self.parameters = parameters
    }
    
    public func build() -> ForBody? {
        guard let data = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: JSONSerialization.WritingOptions()
        ) else {
            return nil
        }
        
        return ForBody(body: data, headers: [
            Header.contentType.rawValue: "application/json"
        ])
    }
}
