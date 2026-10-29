// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AgresNotch",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "Agres Notch", targets: ["AgresNotch"])
    ],
    targets: [
        .target(name: "NotchCore"),
        .executableTarget(
            name: "AgresNotch",
            dependencies: ["NotchCore"],
            
        ),
        .testTarget(
            name: "NotchCoreTests",
            dependencies: ["NotchCore"]
        )
    ]
)
