//
//  FeatureUpvoteBottomCard.swift
//
//  Created by Long Vu on 18/06/2023.
//

import FeatureUpvoteKit
import SwiftUI

public struct FeatureUpvoteBottomCard: View {
    private var primaryAction: () -> Void
    private var secondaryAction: () -> Void
    private var config = Config()

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

            Button {
                primaryAction()
            } label: {
                HStack {
                    Text(L10n.voteOnFeatures)
                        .foregroundColor(.white)
                }
                .frame(height: 44.scaledToMacCatalyst())
                .frame(maxWidth: 350.scaledToMacCatalyst())
                .background(Color.accentColor)
                .cornerRadius(config.cornerRadius)
            }
            .buttonStyle(.plain)

            Button(L10n.Action.later) {
                secondaryAction()
            }
        }
        .padding()
    }
}

public extension FeatureUpvoteBottomCard {
    struct Config {
        var cornerRadius = CGFloat(10).scaledToMacCatalyst()
    }

    func cornerRadius(_ value: CGFloat) -> Self {
        then { $0.config.cornerRadius = value }
    }
}

struct FeatureUpvoteBottomCard_Previews: PreviewProvider {
    static var previews: some View {
        FeatureUpvoteBottomCard(primaryAction: {}, secondaryAction: {})
    }
}
