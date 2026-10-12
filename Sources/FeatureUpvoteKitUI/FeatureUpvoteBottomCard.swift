//
//  FeatureUpvoteBottomCard.swift
//
//  Created by Long Vu on 18/06/2023.
//

import FeatureUpvoteKit
import FeatureUpvoteL10n
import SwiftUI

public struct FeatureUpvoteBottomCard: View {
    private var primaryAction: () -> Void
    private var secondaryAction: () -> Void

    public init(primaryAction: @escaping () -> Void, secondaryAction: @escaping () -> Void) {
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.thumbsup.circle.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundColor(.accentColor)

            VStack {
                Text(L10n.FeatureVoting.title)
                    .font(.title3)
                    .fontWeight(.medium)

                Text(L10n.FeatureVoting.subtitle)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, 6)

            VStack(spacing: 14.scaledToMac()) {
                voteButton

                Button(L10n.Action.later) {
                    secondaryAction()
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private var voteButton: some View {
        if #available(iOS 26, macOS 26, *) {
            Button {
                primaryAction()
            } label: {
                Text(L10n.voteOnFeatures)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
        } else {
            Button {
                primaryAction()
            } label: {
                Text(L10n.voteOnFeatures)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
}

struct FeatureUpvoteBottomCard_Previews: PreviewProvider {
    static var previews: some View {
        FeatureUpvoteBottomCard(primaryAction: {}, secondaryAction: {})
    }
}
