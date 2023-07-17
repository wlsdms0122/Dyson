// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dyson",
    platforms: [
        .iOS(.v13),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Dyson",
            targets: ["Dyson"]
        )
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Dyson",
            dependencies: []
        ),
        .testTarget(
            name: "DysonTests",
            dependencies: [
                "Dyson"
            ]
        )
    ]
)
