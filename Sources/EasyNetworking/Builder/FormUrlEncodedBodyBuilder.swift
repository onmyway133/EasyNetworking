//
//  FormUrlEncodedBodyBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class FormUrlEncodedBodyBuilder: BodyBuilding {
    public let parameters: JSONDictionary
    
    public init(parameters: JSONDictionary) {
        self.parameters = parameters
    }
    
    public func build() -> ForBody? {
        let queryBuilder = QueryBuilder(parameters: parameters)
        let queryItems = queryBuilder.build()
        let query = queryBuilder.build(queryItems: queryItems)
        
        guard let data = query.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }

        return ForBody(body: data, headers: [
            Header.contentType.rawValue: "application/x-www-form-urlencoded"
        ])
    }
}
