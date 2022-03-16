## EasyNetworking

❤️ Support my apps ❤️ 

- [Push Hero - pure Swift native macOS application to test push notifications](https://onmyway133.com/pushhero)
- [PastePal - Pasteboard, note and shortcut manager](https://onmyway133.com/pastepal)
- [Quick Check - smart todo manager](https://onmyway133.com/quickcheck)
- [Alias - App and file shortcut manager](https://onmyway133.com/alias)
- [My other apps](https://onmyway133.com/apps/)

❤️❤️😇😍🤘❤️❤️

## Description

EasyNetworking is a lightweight networking framework for use with async/await 

Features

- Safe URLRequest builder
- Polyfill async URLSession APIs
- Mock

```swift
var client = Client(session: .shared)
client.hook.request = {
    Logger.log(request: $0)
}
client.hook.response = { request, response in
    // Perform mock here
    response
}

var request = Request(url: feedUrl)
request.method = .get
request.headers["Content-Type"] = "application/json"

let response = try await client.data(for: request)
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
