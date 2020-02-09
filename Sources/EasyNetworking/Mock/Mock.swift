//
//  Mock.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class Mock {
    public let options: Options
    public let future: Future<Data>
    
    public init(options: Options, future: Future<Data>) {
        self.options = options
        self.future = future
    }
    
    public static func on(options: Options, data: Data) -> Mock {
        return Mock(options: options, future: Future.complete(value: data))
    }
    
    public static func on(options: Options, error: Error) -> Mock {
        return Mock(options: options, future: Future.fail(error: error))
    }
    
    public static func on(options: Options, file: String, fileExtension: String, bundle: Bundle = Bundle.main) -> Mock {
        guard
            let url = bundle.url(forResource: file, withExtension: fileExtension),
            let data = try? Data(contentsOf: url)
        else {
            return .on(options: options, error: NetworkError.invalidMock)
        }
        
        return .on(options: options, data: data)
    }
}
