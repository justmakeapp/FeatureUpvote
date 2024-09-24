//
//  TranslationView.swift
//  FeatureUpvote
//
//  Created by Long Vu on 31/8/24.
//

import FeatureUpvoteKit
import SwiftUI
#if canImport(Translation)
    import Translation
#endif

#if canImport(Translation) && (os(macOS) || (os(iOS) && !targetEnvironment(macCatalyst)))
    @available(iOS 18.0, macOS 15.0, *)
    struct TranslationView: View {
        @State private var configuration: TranslationSession.Configuration?

        @State private var targetLanguage: Locale.Language?

        @State private var isShowTranslationConfigView = false

        private let languageAvailability = LanguageAvailability()

        let translatables: [TranslatableFeature]
        let onReceiveTranslationResult: ([FeatureTranslation.Response]) -> Void

        init(
            _ translatables: [TranslatableFeature],
            onReceiveTranslationResult: @escaping ([FeatureTranslation.Response]) -> Void
        ) {
            self.translatables = translatables
            self.onReceiveTranslationResult = onReceiveTranslationResult
        }

        var body: some View {
            contentView
                .translationTask(configuration) { session in
                    do {
                        let prepareTranslationTask = Task {
                            try await session.prepareTranslation()
                        }

                        try await prepareTranslationTask.value

                        let batch: [TranslationSession.Request] = translatables
                            .flatMap { $0.makeTranslationSessionRequests() }
                            .map { $0.asRequest() }

                        let batchResponse = session.translate(batch: batch)

                        var result: [TranslationSession.Response] = []
                        for try await response in batchResponse {
                            result.append(response)
                        }
                        onReceiveTranslationResult(result.map { FeatureTranslation.Response(from: $0) })
                    } catch {
                        print(error)
                    }
                }
        }

        private var contentView: some View {
            Button(action: {
                isShowTranslationConfigView = true
            }, label: {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: "translate")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
            })

            .shadow(color: Color(red: 0.06, green: 0.09, blue: 0.16).opacity(0.03), radius: 3, x: 0, y: 4)
            .shadow(color: Color(red: 0.06, green: 0.09, blue: 0.16).opacity(0.08), radius: 8, x: 0, y: 12)
            .sheet(isPresented: $isShowTranslationConfigView) {
                TranslationConfigView(
                    sourceLanguageType: nil,
                    targetLanguage: $targetLanguage,
                    configuration: $configuration
                )
                .presentationDetents([.medium])
            }
        }
    }
#endif

struct PressEffectButtonStyle: ButtonStyle {
    let pressedScale: CGFloat
    init(
        pressedScale: CGFloat = 0.9
    ) {
        self.pressedScale = pressedScale
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.default, value: configuration.isPressed)
    }
}
