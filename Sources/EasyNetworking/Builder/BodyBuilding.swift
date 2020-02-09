//
//  BodyBuilder.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public protocol BodyBuilding {
    func build() -> ForBody?
}

public class EmptyBodyBuilder: BodyBuilding {
    public func build() -> ForBody? {
        return nil
    }
}
