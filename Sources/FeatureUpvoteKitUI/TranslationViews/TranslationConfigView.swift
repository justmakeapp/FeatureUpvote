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
        contentView
            .task { @MainActor in
                let supportedLanguagesTask = Task.detached {
                    return await LanguageAvailability().supportedLanguages
                }

                let result = await supportedLanguagesTask.value

                if
                    sourceLanguage == nil,
                    let sourceLanguageType,
                    case let .languageCode(code) = sourceLanguageType {
                    sourceLanguage = result.first(where: { $0.languageCode?.identifier == code })
                }

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
                    .frame(maxWidth: 150)
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
                    .frame(maxWidth: 150)
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
