// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "skibidipop",
    targets: [
        .executableTarget(
            name: "skibidipop",
            path: "Sources"
        ),
        .testTarget(
            name: "skibidipopTests",
            dependencies: ["skibidipop"]
        )
    ]
)
