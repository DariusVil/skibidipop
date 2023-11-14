// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "skibidipop",
    dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "skibidipop",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "skibidipopTests",
            dependencies: [
                "skibidipop",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        )
    ]
)
