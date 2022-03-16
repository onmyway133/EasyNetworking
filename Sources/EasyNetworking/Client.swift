//
//  Client.swift
//  EasyNetworking
//
//  Created by khoa on 16/03/2022.
//

import Foundation

public struct Client {
    public var session: URLSession = .shared
    public var hook = Hook()

    public init() {}

    public func data(for request: Request) async throws -> Response {
        let urlRequest = try await hook.request(try request.toUrlRequest)
        let (data, urlResponse) = try await safeData(for: urlRequest)
        let response = Response(data: data, urlResponse: urlResponse)
        return try await hook.response(urlRequest, response)
    }

    public func safeData(for request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, *) {
            return try await session.data(for: request, delegate: nil)
        } else {
            return try await withCheckedThrowingContinuation { con in
                let task = session.dataTask(
                    with: request,
                    completionHandler: { data, urlResponse, error in
                        if let error = error {
                            con.resume(throwing: error)
                        } else if let data = data, let urlResponse = urlResponse {
                            con.resume(returning: (data, urlResponse))
                        } else {
                            con.resume(throwing: ClientError.invalidResponse)
                        }
                    }
                )

                task.resume()
            }
        }
    }
}
