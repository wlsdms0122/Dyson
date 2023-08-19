// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dyson",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
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
