//
//  Feature.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import Foundation
#if canImport(Translation)
    import Translation
#endif

public struct Feature: Hashable, Decodable, Identifiable, TranslatableFeature {
    public let id: String
    public let name: String
    public let description: String
    public let tag: String
    public let voteCount: UInt
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        name: String,
        description: String,
        tag: String,
        voteCount: UInt,
        createdAt: Date = .init(),
        updatedAt: Date = .init()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.tag = tag
        self.voteCount = voteCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public func makeTranslationSessionRequests() -> [FeatureTranslation.Request] {
        let name = FeatureTranslation.Request(sourceText: name, clientIdentifier: "\(id)|name")
        let desc = FeatureTranslation.Request(sourceText: description, clientIdentifier: "\(id)|desc")

        return [name, desc]
    }
}

public protocol TranslatableFeature {
    func makeTranslationSessionRequests() -> [FeatureTranslation.Request]
}

public enum FeatureTranslation {
    public struct Request {
        public let sourceText: String
        public let clientIdentifier: String?
    }

    public struct Response {
        public let sourceLanguage: Locale.Language

        public let targetLanguage: Locale.Language

        public let sourceText: String

        public let targetText: String

        public let clientIdentifier: String?

        public init(
            sourceLanguage: Locale.Language,
            targetLanguage: Locale.Language,
            sourceText: String,
            targetText: String,
            clientIdentifier: String? = nil
        ) {
            self.sourceLanguage = sourceLanguage
            self.targetLanguage = targetLanguage
            self.sourceText = sourceText
            self.targetText = targetText
            self.clientIdentifier = clientIdentifier
        }
    }
}

#if canImport(Translation) && (os(macOS) || (os(iOS) && !targetEnvironment(macCatalyst)))
    public extension FeatureTranslation.Request {
        @available(iOS 18.0, macOS 15.0, *)
        func asRequest() -> TranslationSession.Request {
            return .init(sourceText: sourceText, clientIdentifier: clientIdentifier)
        }
    }

    public extension FeatureTranslation.Response {
        @available(iOS 18.0, macOS 15.0, *)
        init(from response: TranslationSession.Response) {
            self.sourceLanguage = response.sourceLanguage
            self.targetLanguage = response.targetLanguage
            self.sourceText = response.sourceText
            self.targetText = response.targetText
            self.clientIdentifier = response.clientIdentifier
        }
    }

#endif
