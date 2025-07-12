// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "GolfTracker",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    targets: [
        .executableTarget(
            name: "GolfTracker",
            path: "Sources/GolfTracker",
            resources: [
                .copy("Info.plist")
            ]
        )
    ]
)
