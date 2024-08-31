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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
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
    }
}

public extension FeatureCellView {
    struct Config {
        var tagColorMap: [String: Color] = [:]
    }

    func tagColorMap(_ value: [String: Color]) -> Self {
        then { $0.config.tagColorMap = value }
    }
}

struct FeatureCellView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FeatureCellView(
                title: "Asana integration Please make an integration with Asana.",
                description: "Please make an integration with Asana.",
                tag: "Open"
            ) {
                VoteButton(voteCount: 0, hasVoted: false)
            }
        }
    }
}
