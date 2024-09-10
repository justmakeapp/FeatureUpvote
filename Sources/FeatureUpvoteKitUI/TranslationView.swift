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
                TranslationConfigView(configuration: $configuration)
                    .presentationDetents([.medium])
            }
        }
    }

    @available(iOS 18.0, macOS 15.0, *)
    private struct TranslationConfigView: View {
        @State private var sourceLanguage: Locale.Language?
        @State private var targetLanguage: Locale.Language?
        @State private var availableLanguages = [Locale.Language]()

        @Binding var configuration: TranslationSession.Configuration?

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            contentView
                .task { @MainActor in
                    let supportedLanguagesTask = Task.detached {
                        return await LanguageAvailability().supportedLanguages
                    }

                    let result = await supportedLanguagesTask.value
                    sourceLanguage = result.first
                    targetLanguage = result
                        .first(where: { $0.languageCode?.identifier == Locale.firstPreferredLanguageID })
                    availableLanguages = result
                }
        }

        private var contentView: some View {
            VStack(spacing: 24) {
                VStack {
                    HStack {
                        Label("Source Language", systemImage: "book.closed")

                        Spacer()

                        Picker("", selection: $sourceLanguage) {
                            ForEach(availableLanguages, id: \.self) { language in
                                Text(Locale.current
                                    .localizedString(forIdentifier: language.minimalIdentifier) ?? "")
                                    .tag(language)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }

                    HStack {
                        Label("Target Language", systemImage: "globe")

                        Spacer()

                        Picker("", selection: $targetLanguage) {
                            ForEach(availableLanguages, id: \.self) { language in
                                Text(Locale.current
                                    .localizedString(forIdentifier: language.minimalIdentifier) ?? "")
                                    .tag(language)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }

                Button {
                    self.configuration = TranslationSession.Configuration(
                        source: sourceLanguage,
                        target: targetLanguage
                    )

                    dismiss()
                } label: {
                    HStack {
                        Label("Translate", systemImage: "translate")
                            .foregroundStyle(.white)
                    }
                    .frame(height: 44.scaledToMac())
                    .frame(maxWidth: 400)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                }
                .buttonStyle(PressEffectButtonStyle())
                .disabled(sourceLanguage == nil && targetLanguage == nil)

                Spacer()
            }
            .padding()
        }
    }
#endif

private struct PressEffectButtonStyle: ButtonStyle {
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
