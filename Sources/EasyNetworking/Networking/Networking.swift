//
//  Networking.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class Networking {
    public let session: URLSession
    public let mockManager = MockManager()
    
    public var before: (URLRequest) -> URLRequest = { $0 }
    public var catchError: (Error) -> Future<Response> = { error in Future.fail(error: error) }
    public var validate: (Response) -> Future<Response> = { Future.complete(value: $0) }
    public var logResponse: (Result<Response, Error>) -> Void = { _ in }
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func make(options: Options, baseUrl: URL) -> Future<Response> {
        let builder = UrlRequestBuilder()
        do {
            let request = try builder.build(options: options, baseUrl: baseUrl)
            return make(request: request)
        } catch {
            return Future<Response>.fail(error: error)
        }
    }
    
    public func make(request: URLRequest) -> Future<Response> {
        if let mock = mockManager.findMock(request: request) {
            return mock.future.map(transform: { Response(data: $0, urlResponse: URLResponse()) })
        }
        
        let future = Future<Response>(work: { resolver in
            let task = self.session.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data, let urlResponse = response {
                    resolver.complete(value: Response(data: data, urlResponse: urlResponse))
                } else if let error = error {
                    resolver.fail(error: NetworkError.urlSession(error, response))
                } else {
                    resolver.fail(error: NetworkError.unknownError)
                }
            })
            
            resolver.token.onCancel {
                task.cancel()
            }
            
            task.resume()
        })
        
        return future
            .catchError(transform: self.catchError)
            .flatMap(transform: self.validate)
            .log(closure: self.logResponse)
    }
}
