//
//  FeatureCellView.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import SwiftUI

public struct FeatureCellView: View {
    private let title: String
    private let description: String
    private let tag: String
    private let voteButtonBuilder: () -> VoteButton

    private var config = Config()

    public init(
        title: String,
        description: String,
        tag: String,
        @ViewBuilder voteButtonBuilder: @escaping () -> VoteButton
    ) {
        self.title = title
        self.description = description
        self.tag = tag
        self.voteButtonBuilder = voteButtonBuilder
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    TagView(title: tag)
                        .disabled()
                        .accentColor(config.tagColorMap[tag])

                    Text(title)
                        .lineLimit(2)
                        .font(.body)
                        .fontWeight(.medium)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                voteButtonBuilder()
            }

            translationView
        }
    }

    @ViewBuilder
    private var translationView: some View {
        if let translatedTitle = config.translatedTitle, let translatedDesc = config.translatedDesc {
            VStack(alignment: .leading) {
                Text(translatedTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(translatedDesc)
                    .font(.footnote)
                    .fontWeight(.regular)
            }
            .padding(.vertical, 6)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .modifier {
                if #available(iOS 17.0, *) {
                    $0
                        .background(.background.secondary)
                } else {
                    $0
                        .background(Color(uiColor: .secondarySystemBackground))
                }
            }

            .cornerRadius(8)
        }
    }
}

public extension FeatureCellView {
    struct Config {
        var tagColorMap: [String: Color] = [:]
        var translatedTitle: String?
        var translatedDesc: String?
    }

    func tagColorMap(_ value: [String: Color]) -> Self {
        then { $0.config.tagColorMap = value }
    }

    func translatedTitle(_ value: String?) -> Self {
        then { $0.config.translatedTitle = value }
    }

    func translatedDescription(_ value: String?) -> Self {
        then { $0.config.translatedDesc = value }
    }
}

struct FeatureCellView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FeatureCellView(
                title: "Asana integration",
                description: "Please make an integration with Asana.",
                tag: "Open"
            ) {
                VoteButton(voteCount: 0, hasVoted: false)
            }
            .translatedTitle("Asana連携")
            .translatedDescription("Asanaとの連携をお願いします。")
        }
    }
}
