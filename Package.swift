// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "FeatureUpvote",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
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
    ],
    swiftLanguageModes: [.v6]
)
