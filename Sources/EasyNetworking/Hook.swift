//
//  Hook.swift
//  EasyNetworking
//
//  Created by khoa on 16/03/2022.
//

import Foundation

public struct Hook {
    public var request: (URLRequest) async throws -> URLRequest = { $0 }
    public var response: (URLRequest, Response) async throws -> Response = { $1 }

    public init() {}
}

public struct Logger {
    public static func log(request: URLRequest) {
        #if DEBUG
        print(request.cURL())
        #endif
    }
}

private extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(url?.absoluteString ?? "")\' \(newLine)"

        var cURL = "curl "
        var header = ""
        var data: String = ""

        if let headers = allHTTPHeaderFields,
           !headers.keys.isEmpty {
            for (key, value) in headers {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }

        if let body = httpBody,
            let bodyString = String(data: body, encoding: .utf8),
            !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }

        cURL += method + url + header + data

        return cURL
    }
}
