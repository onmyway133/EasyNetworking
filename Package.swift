// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyNetworking",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "EasyNetworking",
            targets: ["EasyNetworking"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EasyNetworking",
            dependencies: []
        ),
        .testTarget(
            name: "EasyNetworkingTests",
            dependencies: ["EasyNetworking"]
        ),
    ]
)
