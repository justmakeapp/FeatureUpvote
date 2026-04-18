//  Created by Claude on 18/04/2026.

import FeatureUpvoteKit
import FeatureUpvoteL10n
import SwiftUI

public struct FeatureUpvoteHomeBanner: View {
    private let features: [Feature]
    private let votedFeatureIDs: Set<String>
    private let onVote: (Feature, Bool) async throws -> Void
    private let onShowAll: () -> Void
    private let onClose: () -> Void

    private var config = Config()

    public init(
        features: [Feature],
        votedFeatureIDs: Set<String>,
        onVote: @escaping (Feature, _ isVoting: Bool) async throws -> Void,
        onShowAll: @escaping () -> Void,
        onClose: @escaping () -> Void
    ) {
        self.features = features
        self.votedFeatureIDs = votedFeatureIDs
        self.onVote = onVote
        self.onShowAll = onShowAll
        self.onClose = onClose
    }

    public var body: some View {
        if features.isEmpty {
            EmptyView()
                .frame(height: 0)
        } else {
            cardContent
        }
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow

            VStack(spacing: 8) {
                ForEach(features) { feature in
                    featureRow(feature)
                }
            }

            HStack {
                Spacer()
                Button(action: onShowAll) {
                    Text(L10n.FeatureVoting.HomeBanner.showAll)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.tint)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.accentColor.opacity(0.08))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var headerRow: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.FeatureVoting.HomeBanner.title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(L10n.FeatureVoting.HomeBanner.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(6)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(L10n.FeatureVoting.HomeBanner.closeAccessibilityLabel))
        }
    }

    private func featureRow(_ feature: Feature) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                TagView(title: feature.tag)
                    .disabled()
                    .tint(config.tagColorMap[feature.tag])
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VoteButton(
                voteCount: feature.voteCount,
                hasVoted: votedFeatureIDs.contains(feature.id)
            )
            .onVote { isVoting in
                try await onVote(feature, isVoting)
            }
        }
    }
}

public extension FeatureUpvoteHomeBanner {
    struct Config {
        var tagColorMap: [String: Color] = [:]
    }

    func tagColorMap(_ value: [String: Color]) -> Self {
        then { $0.config.tagColorMap = value }
    }
}

#if DEBUG
    private let previewFeatures: [Feature] = [
        Feature(
            id: "f1",
            name: "Dark mode for flashcards",
            description: "Let me study at night without burning my eyes.",
            tag: "Open",
            voteCount: 42
        ),
        Feature(
            id: "f2",
            name: "Sync with Anki decks",
            description: "Import and export my existing Anki collection.",
            tag: "In Progress",
            voteCount: 29
        ),
        Feature(
            id: "f3",
            name: "Offline AI generation",
            description: "Generate flashcards from notes on-device.",
            tag: "Open",
            voteCount: 17
        ),
    ]

    #Preview("3 features, none voted") {
        FeatureUpvoteHomeBanner(
            features: previewFeatures,
            votedFeatureIDs: [],
            onVote: { _, _ in },
            onShowAll: {},
            onClose: {}
        )
        .padding()
    }

    #Preview("3 features, 1 voted") {
        FeatureUpvoteHomeBanner(
            features: previewFeatures,
            votedFeatureIDs: ["f2"],
            onVote: { _, _ in },
            onShowAll: {},
            onClose: {}
        )
        .padding()
    }

    #Preview("1 feature only") {
        FeatureUpvoteHomeBanner(
            features: [previewFeatures[0]],
            votedFeatureIDs: [],
            onVote: { _, _ in },
            onShowAll: {},
            onClose: {}
        )
        .padding()
    }
#endif
