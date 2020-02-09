//
//  MockManager.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class MockManager {
    public var mocks = [Mock]()

    public func register(_ mock: Mock) {
        mocks.append(mock)
    }
    
    public func findMock(request: URLRequest) -> Mock? {
        guard let url = request.url else {
            return nil
        }

        guard let mock = mocks.first(where: { url.absoluteString.contains($0.options.path) }) else {
            return nil
        }
        
        return mock
    }
}
