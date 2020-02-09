//
//  MultipartFormBodyBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class MultipartFormBodyBuilder: BodyBuilder {
    public let parameters: JSONDictionary
    public let boundary: String
    
    public init(parameters: JSONDictionary, boundary: String = "EasyNetworking") {
        self.parameters = parameters
        self.boundary = boundary
    }
    
    public func build() -> ForBody? {
        let string = self.string(parameters: parameters)
        
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        
        return ForBody(body: data, headers: [
            Header.contentType.rawValue: "multipart/form-data; boundary=\(boundary)"
        ])
    }
    
    public func string(parameters: JSONDictionary) -> String {
        var string = ""
        let queryBuilder = DefaultQueryBuilder(parameters: parameters)
        let queryItems = queryBuilder.build()
        queryItems.forEach({ item in
            guard let value = item.value else {
                return
            }
            
            string += "--\(boundary)\r\n"
            string += "Content-Disposition: form-data; name=\"\(item.name)\"\r\n\r\n"
            string += "\(value)\r\n"
        })
        
        string += "--\(boundary)--\r\n"
        return string
    }
}
