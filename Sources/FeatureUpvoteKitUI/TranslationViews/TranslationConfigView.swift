//
//  TranslationConfigView.swift
//  FeatureUpvote
//
//  Created by Long Vu on 24/9/24.
//

import SwiftUI
#if canImport(Translation)
    import Translation
#endif
import FeatureUpvoteL10n

#if canImport(Translation) && (os(macOS) || (os(iOS) && !targetEnvironment(macCatalyst)))
    @available(iOS 18.0, macOS 15.0, *)
    public struct TranslationConfigView: View {
        public enum LanguageType {
            case languageCode(String)
            case localLanguage(Locale.Language)
        }

        private let sourceLanguageType: LanguageType?
        @State private var sourceLanguage: Locale.Language?
        @Binding private var targetLanguage: Locale.Language?
        @State private var availableLanguages = [Locale.Language]()

        @Binding var configuration: TranslationSession.Configuration?

        @Environment(\.dismiss) private var dismiss

        public init(
            sourceLanguageType: LanguageType?,
            targetLanguage: Binding<Locale.Language?>,
            configuration: Binding<TranslationSession.Configuration?>
        ) {
            self.sourceLanguageType = sourceLanguageType
            _sourceLanguage = .init(wrappedValue: {
                guard let sourceLanguageType else {
                    return nil
                }

                switch sourceLanguageType {
                case .languageCode:
                    return nil
                case let .localLanguage(language):
                    return language
                }
            }())
            _targetLanguage = targetLanguage
            _configuration = configuration
        }

        public var body: some View {
            containerView
                .task { @MainActor in
                    let supportedLanguagesTask = Task.detached {
                        return await LanguageAvailability().supportedLanguages
                    }

                    let result = await supportedLanguagesTask.value

                    if sourceLanguage == nil {
                        if
                            let sourceLanguageType,
                            case let .languageCode(code) = sourceLanguageType {
                            sourceLanguage = result.first(where: { $0.languageCode?.identifier == code })
                        } else {
                            sourceLanguage = result.first
                        }
                    }

                    targetLanguage = result
                        .first(where: { $0.languageCode?.identifier == Locale.firstPreferredLanguageID })

                    availableLanguages = result
                }
        }

        @ViewBuilder
        private var containerView: some View {
            NavigationStack {
                contentView
                    .toolbar {
                        #if os(macOS)
                            ToolbarItem(placement: .cancellationAction) {
                                cancelButton
                            }

                            ToolbarItem(placement: .confirmationAction) {
                                translateButton
                            }
                        #endif

                        #if os(iOS)
                            ToolbarItem(placement: .topBarTrailing) {
                                cancelButton
                            }
                        #endif
                    }
                    .presentationDetents([.medium, .large])
            }
            .presentationDragIndicator(.visible)
        }

        private var contentView: some View {
            GeometryReader { proxy in
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
                            .frame(minWidth: 100, maxWidth: max(100, proxy.size.width / 2))
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
                            .frame(minWidth: 100, maxWidth: max(100, proxy.size.width / 2))
                        }

                        HStack {
                            Spacer()

                            switchButton
                        }
                    }

                    Spacer()
                    #if os(iOS)
                        VStack {
                            translateButton
                        }
                    #endif
                }
                .padding()
            }
            #if os(macOS)
            .frame(minHeight: 160)
            #endif
        }

        private var switchButton: some View {
            Button {
                let source = sourceLanguage
                sourceLanguage = targetLanguage
                targetLanguage = source
            } label: {
                HStack {
                    Spacer()

                    Label("Swap languages", systemImage: "rectangle.2.swap")
                        .foregroundStyle(.tint)
                }
                #if os(iOS)
                .frame(height: 44.scaledToMac())
                .frame(maxWidth: 400)
                #endif
            }
            .buttonStyle(PressEffectButtonStyle())
            .disabled(sourceLanguage == nil || targetLanguage == nil)
        }

        private var translateButton: some View {
            Button {
                self.configuration = TranslationSession.Configuration(
                    source: sourceLanguage,
                    target: targetLanguage
                )

                dismiss()
            } label: {
                Label(FeatureUpvoteL10n.L10n.Action.translate, systemImage: "translate")
            }
            .modifier {
                if #available(iOS 26, macOS 26.0, *) {
                    $0.buttonStyle(.glassProminent)
                } else {
                    $0.buttonStyle(.borderedProminent)
                }
            }
            .buttonBorderShape(.capsule)
            .disabled(sourceLanguage == nil && targetLanguage == nil)
        }

        private var cancelButton: some View {
            Button(FeatureUpvoteL10n.L10n.Action.cancel) {
                dismiss()
            }
            .buttonBorderShape(.capsule)
        }
    }
#endif
