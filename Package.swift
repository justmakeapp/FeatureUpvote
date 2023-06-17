// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "FeatureUpvote",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "FeatureUpvoteKit",
            targets: ["FeatureUpvoteKit"]
        ),
        .library(
            name: "FeatureUpvoteKitUI",
            targets: ["FeatureUpvoteKitUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/justmakeapp/ColorKit", branch: "main"),
    ],
    targets: [
        .target(
            name: "FeatureUpvoteKit"
        ),
        .target(
            name: "FeatureUpvoteKitUI",
            dependencies: [
                "ColorKit",
                "FeatureUpvoteKit",
            ]
        ),
    ]
)
