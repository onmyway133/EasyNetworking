//
//  NetworkError.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest(Options)
    case invalidMock
    case urlSession(Error, URLResponse?)
    case unknownError
    case cancelled
}
