## EasyNetworking

❤️ Support my apps ❤️ 

- [Push Hero - pure Swift native macOS application to test push notifications](https://onmyway133.com/pushhero)
- [PastePal - Pasteboard, note and shortcut manager](https://onmyway133.com/pastepal)
- [Quick Check - smart todo manager](https://onmyway133.com/quickcheck)
- [Alias - App and file shortcut manager](https://onmyway133.com/alias)
- [My other apps](https://onmyway133.com/apps/)

❤️❤️😇😍🤘❤️❤️

## Description

Since iOS 7+, there is `URLSession` and it is great, no need for any wrappers. What I need in a networking library is some convenient helpers to make `URLRequest` and to chain request in a type safe way. That's why I build `EasyNetworking`.

Features

- Doesn't wrap `URLSession`
- Build request header, body and parameters with proper encoding
- Chain request with built in Future
- Mock

## Usage

### Declare Networking

Use `Networking` to execute request

```swift
let networking = Networking(session: .shared)
let future = networking.make(request: URLRequest(url: URL(string: "https://example.com/movie.json")!))
future.run { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
}
```

### Listen to Networking events

By default, `Future` returned by `Networking` runs through a chain

```swift
Networking.make

return future
    .catchError(transform: self.catchError)
    .flatMap(transform: self.validate)
    .log(closure: self.logResponse)
```

Networking provides hooks so you can customize the behavior

```swift
networking.before = { request in
    print("run before each request")
}

networking.catchError = { error in
    print("catch error and return another Future")
    return  Future.fail(error: error)
}

networking.validate = { response in
    print("validate response and return another Future")
    Future.complete(value: response)
}

networking.logResponse = { response in
    print("log response")
}
```

### Make URLRequest from options

Use `Options`to specify request properties.

```swift
public struct Options {
    public var path: String = ""
    public var queryBuilder: QueryBuilding = QueryBuilder()
    public var bodyBuilder: BodyBuilding = EmptyBodyBuilder()
    public var headers: [String: String] = [:]
    public var httpMethod: HttpMethod = .get
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    public init() {}
}
```

To build body, conform to `BodyBuilding` or use predefined builders

- `EmptyBodyBuilder`
- `FormUrlEncodedBodyBuilder`
- `JsonBodyBuilder`
- `MultipartFormBodyBuilder`

To build parameters, conform to `QueryBuilding` or use predefined builders

- `QueryBuilder` which uses `ParameterParser`

To build `URLRequest` from `Options`, use `UrlRequestBuilder`

```swift
var options = Options()
options.httpMethod = .patch
options.path = "search"
options.queryBuilder = QueryBuilder(parameters: [
    "q": "pokemon",
    "size": "10"
])

options.headers = [
    "My-Header": "My-Header-Value"
]

options.cachePolicy = .reloadIgnoringCacheData

let builder = UrlRequestBuilder()
let request = try builder.build(options: options, baseUrl: URL(string: "https://google.com")!)
```

## Proper error handling

Use enum to catch all possible errors

```swift
public enum NetworkError: Error {
    case invalidRequest(Options)
    case invalidMock
    case urlSession(Error, URLResponse?)
    case unknownError
    case cancelled
}
```

## Mock

Mock is used in testing and when the server is not ready. You can create `Mock` based on fixed `Data`, contents of file or just return `Error`

```swift
let networking = Networking(session: .shared)
networking.mockManager.register(.on(options: Options(), data: testData)
```

## Installation

**EasyNetworking** is also available through [Swift Package Manager](https://swift.org/package-manager/)

```swift
.package(url: "https://github.com/onmyway133/EasyNetworking", from: "1.0.0")
```

## Author

Khoa Pham, onmyway133@gmail.com

## License

**EasyNetworking** is available under the MIT license. See the [LICENSE](https://github.com/onmyway133/EasyNetworking/blob/master/LICENSE.md) file for more info.
