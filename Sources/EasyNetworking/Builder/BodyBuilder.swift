//
//  BodyBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public protocol BodyBuilder {
    func build() -> ForBody?
}

public class DefaultBodyBuilder: BodyBuilder {
    public func build() -> ForBody? {
        return nil
    }
}
