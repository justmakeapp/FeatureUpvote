// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FeatureUpvote",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "FeatureUpvoteKit",
            targets: ["FeatureUpvoteKit"]
        ),
        .library(
            name: "FeatureUpvoteL10n",
            targets: ["FeatureUpvoteL10n"]
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
            name: "FeatureUpvoteL10n"
        ),
        .target(
            name: "FeatureUpvoteKitUI",
            dependencies: [
                "FeatureUpvoteKit",
                "FeatureUpvoteL10n"
            ]
        ),
    ]
)
