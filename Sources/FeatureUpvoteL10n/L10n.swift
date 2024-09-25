// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
    /// Empty
    public static let empty = L10n.tr("Localizable", "empty", fallback: "Empty")
    /// Vote on Features
    public static let voteOnFeatures = L10n.tr("Localizable", "voteOnFeatures", fallback: "Vote on Features")
    public enum Action {
        /// Cancel
        public static let cancel = L10n.tr("Localizable", "action.cancel", fallback: "Cancel")
        /// Create
        public static let create = L10n.tr("Localizable", "action.create", fallback: "Create")
        /// Later
        public static let later = L10n.tr("Localizable", "action.later", fallback: "Later")
        /// Translate
        public static let translate = L10n.tr("Localizable", "action.translate", fallback: "Translate")
    }

    public enum Error {
        /// Feature description should more than %d characters
        public static func featureDescShoudMoreThanXCharacters(_ p1: Int) -> String {
            return L10n.tr(
                "Localizable",
                "error.featureDescShoudMoreThanXCharacters",
                p1,
                fallback: "Feature description should more than %d characters"
            )
        }

        /// Feature name should more than %d characters
        public static func featureNameShoudMoreThanXCharacters(_ p1: Int) -> String {
            return L10n.tr(
                "Localizable",
                "error.featureNameShoudMoreThanXCharacters",
                p1,
                fallback: "Feature name should more than %d characters"
            )
        }

        /// Error
        public static let title = L10n.tr("Localizable", "error.title", fallback: "Error")
    }

    public enum Feature {
        /// Feature Description
        public static let desc = L10n.tr("Localizable", "feature.desc", fallback: "Feature Description")
        /// Feature Name
        public static let name = L10n.tr("Localizable", "feature.name", fallback: "Feature Name")
        /// New Feature
        public static let new = L10n.tr("Localizable", "feature.new", fallback: "New Feature")
    }

    public enum FeatureVoting {
        /// Share your desired new features and areas for improvement. Vote for your favorite features to enhance this
        /// application.
        public static let subtitle = L10n.tr(
            "Localizable",
            "featureVoting.subtitle",
            fallback: "Share your desired new features and areas for improvement. Vote for your favorite features to enhance this application."
        )
        /// Feature Voting
        public static let title = L10n.tr("Localizable", "featureVoting.title", fallback: "Feature Voting")
    }

    public enum SortOrder {
        /// Ascending
        public static let ascending = L10n.tr("Localizable", "sortOrder.ascending", fallback: "Ascending")
        /// Descending
        public static let descending = L10n.tr("Localizable", "sortOrder.descending", fallback: "Descending")
    }

    public enum Sorting {
        /// Alphabetical
        public static let alphabetical = L10n.tr("Localizable", "sorting.alphabetical", fallback: "Alphabetical")
        /// Comming Soon
        public static let commingSoon = L10n.tr("Localizable", "sorting.commingSoon", fallback: "Comming Soon")
        /// Created Date
        public static let createdDate = L10n.tr("Localizable", "sorting.createdDate", fallback: "Created Date")
        /// Sort by
        public static let sortBy = L10n.tr("Localizable", "sorting.sortBy", fallback: "Sort by")
        /// Updated Date
        public static let updatedDate = L10n.tr("Localizable", "sorting.updatedDate", fallback: "Updated Date")
    }

    public enum Tag {
        /// Closed
        public static let closed = L10n.tr("Localizable", "tag.closed", fallback: "Closed")
        /// Done
        public static let done = L10n.tr("Localizable", "tag.done", fallback: "Done")
        /// In Progress
        public static let inProgress = L10n.tr("Localizable", "tag.inProgress", fallback: "In Progress")
        /// Open
        public static let open = L10n.tr("Localizable", "tag.open", fallback: "Open")
    }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
