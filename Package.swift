// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LiteShunt",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "LiteShuntShared",
            targets: ["LiteShuntShared"]
        ),
        .library(
            name: "LiteShuntCore",
            targets: ["LiteShuntCore"]
        ),
        .executable(
            name: "LiteShuntSmokeTests",
            targets: ["LiteShuntSmokeTests"]
        )
    ],
    targets: [
        .target(
            name: "LiteShuntShared"
        ),
        .target(
            name: "LiteShuntCore",
            dependencies: ["LiteShuntShared"]
        ),
        .executableTarget(
            name: "LiteShuntSmokeTests",
            dependencies: ["LiteShuntCore", "LiteShuntShared"]
        ),
        .testTarget(
            name: "LiteShuntSharedTests",
            dependencies: ["LiteShuntShared"]
        ),
        .testTarget(
            name: "LiteShuntCoreTests",
            dependencies: ["LiteShuntCore", "LiteShuntShared"]
        )
    ]
)
