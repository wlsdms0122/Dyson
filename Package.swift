// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aim",
    platforms: [
        .iOS(.v13),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Aim",
            targets: ["Aim"]
        )
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "Aim",
            dependencies: []
        ),
        .testTarget(
            name: "AimTests",
            dependencies: [
                "Aim"
            ],
            resources: [
                .process("Asset")
            ]
        )
    ]
)
