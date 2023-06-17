// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "FeatureUpvote",
    defaultLocalization: "en",
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
    targets: [
        .target(
            name: "FeatureUpvoteKit"
        ),
        .target(
            name: "FeatureUpvoteKitUI",
            dependencies: [
                "FeatureUpvoteKit",
            ]
        ),
    ]
)
