// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        .library(
            name: "RxNetwork",
            targets: ["RxNetwork"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.0.0")),
        // Test
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                "Alamofire"
            ]
        ),
        .target(
            name: "RxNetwork",
            dependencies: [
                "Network",
                "RxSwift"
            ]
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: [
                "Network",
                "Quick",
                "Nimble"
            ]
        )
    ]
)
