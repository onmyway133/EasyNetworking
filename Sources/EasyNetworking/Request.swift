//
//  Request.swift
//  EasyNetworking
//
//  Created by khoa on 16/03/2022.
//

import Foundation

public enum ClientError: Error {
    case invalidRequest
    case invalidResponse
}

public struct Request {
    public var url: URL
    public var path: String?
    public var parameters: [String: String] = [:]
    public var method: HttpMethod = .get
    public var headers: [String: String] = [:]
    public var body: Data?

    public var toUrlRequest: URLRequest {
        get throws {
            guard
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                throw ClientError.invalidRequest
            }

            if let path = path {
                components.path = path
            }

            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }

            guard
                let url = components.url
            else {
                throw ClientError.invalidRequest
            }

            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            request.httpBody = body

            return request
        }
    }
}

public struct HttpMethod: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let get = Self(rawValue: "GET")
    public static let post = Self(rawValue: "POST")
    public static let put = Self(rawValue: "PUT")
    public static let patch = Self(rawValue: "PATCH")
    public static let delete = Self(rawValue: "DELETE")
    public static let head = Self(rawValue: "HEAD")
}

public struct Header {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let contentType = Self(rawValue: "Content-Type")
    public static let userAgent = Self(rawValue: "User-Agent")
}

public struct ContentType {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let json = Self(rawValue: "application/json")
    public static let formUrlEncoded = Self(rawValue: "application/x-www-form-urlencoded")
    public static func formDataMultipart(boundary: String) -> Self {
        Self(rawValue: "multipart/form-data; boundary=\(boundary)")
    }
}
