import XCTest
@testable import EasyNetworking

final class EasyNetworkingTests: XCTestCase {
    func testExample() {
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
    }

    func testMock() {
        let networking = Networking(session: .shared)
        networking.mockManager.register(.on(options: Options(), data: Data()))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
