// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AgresNotch",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "Agres Notch", targets: ["EzkielNotch"])
    ],
    targets: [
        .target(name: "NotchCore"),
        .executableTarget(
            name: "EzkielNotch",
            dependencies: ["NotchCore"]
        ),
        .testTarget(
            name: "NotchCoreTests",
            dependencies: ["NotchCore"]
        )
    ]
)
