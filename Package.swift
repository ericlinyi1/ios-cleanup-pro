// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "iOSCleanupPro",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "iOSCleanupPro",
            targets: ["CoreLogic", "AIModule", "UIModule"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreLogic",
            dependencies: [],
            path: "Sources/CoreLogic",
            resources: []
        ),
        .target(
            name: "AIModule",
            dependencies: [],
            path: "Sources/AIModule"
        ),
        .target(
            name: "UIModule",
            dependencies: ["CoreLogic", "AIModule"],
            path: "Sources/UIModule",
            resources: [
                .process("../../Resources")
            ]
        ),
        .testTarget(
            name: "iOSCleanupProTests",
            dependencies: ["CoreLogic", "AIModule", "UIModule"],
            path: "tests"
        )
    ]
)
