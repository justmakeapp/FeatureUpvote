//
//  VoteButton.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import SwiftUI

public struct VoteButton: View {
    @State private var isHovering = false

    @State private var hasVoted: Bool

    @State private var voteCount: UInt

    public init(voteCount: UInt, hasVoted: Bool) {
        _voteCount = .init(initialValue: voteCount)
        _hasVoted = .init(initialValue: hasVoted)
    }

    private var showNumber: Bool {
        voteCount > 0
    }

    private var config = Config()
    @State private var canTap = true

    public var body: some View {
        Button {
            Task {
                guard canTap else {
                    return
                }
                canTap = false

                toggleVote()

                #if os(iOS)
                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                    haptic.impactOccurred()
                #endif

                do {
                    try await config.onVote(hasVoted)
                } catch {
                    toggleVote()
                }
                canTap = true
            }
        } label: {
            VStack(spacing: isHovering ? 6 : 4) {
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(hasVoted ? selectedForegroundColor : Color.accentColor)
                    .font(.title3)
                    .imageScale(.large)

                if showNumber {
                    Text("\(voteCount)")
                        .foregroundColor(hasVoted ? selectedForegroundColor : Color.accentColor)
                        .minimumScaleFactor(0.9)
                }
            }
            .frame(minWidth: 60.scaledToMac())
            .frame(minHeight: 60.scaledToMac())
            .background(backgroundView)
            .contentShape(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
            .overlay(overlayBorder)
        }
        .buttonStyle(.plain)
        .onHover { newHover in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                isHovering = newHover
            }
        }
//        .onAppear {
//            showNumber = viewModel.voteCount > 0
//            withAnimation(.spring(response: 0.45, dampingFraction: 0.4, blendDuration: 0)) {
//                hasVoted = viewModel.feature.hasVoted
//            }
//        }
//        .accessibilityHint(viewModel.canVote ? Text("Vote for \(viewModel.feature.localizedFeatureTitle)") : Text(""))
//        .help(viewModel.canVote ? "Vote for \(viewModel.feature.localizedFeatureTitle)" : "")
//        .animateAccessible()
//        .accessibilityShowsLargeContentViewer()
    }

    private var selectedForegroundColor: Color {
        .white
    }

    private func toggleVote() {
        withAnimation {
            hasVoted.toggle()

            voteCount = hasVoted ? voteCount + 1 : voteCount - 1
        }
    }

    @ViewBuilder
    var overlayBorder: some View {
        if isHovering {
            RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                .stroke(Color.accentColor, lineWidth: 1)
        }
    }

    private var backgroundView: some View {
        Color.accentColor
            .opacity(hasVoted ? 1 : 0.1)
            .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
    }
}

public extension VoteButton {
    struct Config {
        var cornerRadius: CGFloat = 10.scaledToMac()
        var onVote: (Bool) async throws -> Void = { _ in }
    }

    func onVote(_ value: @escaping (Bool) async throws -> Void) -> Self {
        then { $0.config.onVote = value }
    }
}

struct VoteButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VoteButton(voteCount: 1, hasVoted: true)

            VoteButton(voteCount: 0, hasVoted: false)
                .onVote { isVote in
                    if isVote {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                    } else {}
                }

            VoteButton(voteCount: 1, hasVoted: false)
                .onVote { isVote in
                    if isVote {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        throw NSError()
                    } else {}
                }
        }
        .padding()
    }
}
