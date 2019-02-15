// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCPServer",
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", .exact("1.5.1")),
    ],
    targets: [
        .target(
            name: "TCPServer",
            dependencies: ["NIO"]),
        .testTarget(
            name: "TCPServerTests",
            dependencies: ["TCPServer"]),
    ]
)
