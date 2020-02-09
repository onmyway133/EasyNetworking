// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyNetworking",
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
