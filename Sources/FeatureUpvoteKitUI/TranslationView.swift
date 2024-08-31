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

#if canImport(Translation) && (os(macOS) || os(iOS))
    @available(iOS 18.0, macOS 15.0, *)
    struct TranslationView: View {
        @State private var configuration: TranslationSession.Configuration?

        @State private var targetLanguage: Locale.Language?
        @State private var availableLanguages = [Locale.Language]()
        @State private var translating = false

        @State private var canTranslate = false

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
                .task { @MainActor in
                    let supportedLanguagesTask = Task.detached {
                        return await LanguageAvailability().supportedLanguages
                    }

                    let result = await supportedLanguagesTask.value
                    targetLanguage = result
                        .first(where: { $0.languageCode?.identifier == Locale.firstPreferredLanguageID })
                    availableLanguages = result
                }
                .task(id: targetLanguage) { [languageAvailability] in
                    if let targetLanguage {
                        do {
                            let status = try await languageAvailability.status(
                                for: "Hello",
                                to: targetLanguage
                            )
                            switch status {
                            case .installed, .supported:
                                canTranslate = true
                            case .unsupported:
                                canTranslate = false
                            @unknown default:
                                canTranslate = false
                            }
                        } catch {
                            print(error)
                            canTranslate = false
                        }
                    } else {
                        canTranslate = false
                    }
                }
                .translationTask(configuration) { session in
                    do {
                        translating = true

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

                    translating = false
                }
        }

        private var contentView: some View {
            HStack {
                Spacer()

                if targetLanguage != nil {
                    Picker("Language", systemImage: "globe", selection: $targetLanguage) {
                        ForEach(availableLanguages, id: \.self) { language in
                            Text(Locale.current.localizedString(forIdentifier: language.minimalIdentifier) ?? "")
                                .tag(language)
                        }
                    }
                    .padding(.horizontal)
                }

                Button("Translate", systemImage: "translate") {
                    if configuration == nil {
                        self.configuration = TranslationSession.Configuration(source: nil, target: targetLanguage)
                    } else {
                        self.configuration?.invalidate()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canTranslate || translating)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
#endif
