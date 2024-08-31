//
//  FeatureUpvoteView.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import FeatureUpvoteKit
import SwiftUI
#if os(macOS)
    import AppKit.NSColor
#else
    import UIKit.UIColor
#endif
#if canImport(Translation)
import Translation
#endif

public struct FeatureUpvoteView<
    Collection: RandomAccessCollection,
    CellView: View,
    HeaderView: View
>: View where Collection.Element: Hashable & Identifiable & TranslatableFeature {
    private var data: Collection
    private var cellBuilder: (
        Collection.Element,
        _ translations: [FeatureTranslation.Response]
    ) -> CellView
    private var headerBuilder: () -> HeaderView

    private var config = Config()

    @State private var translations: [AnyHashable: [FeatureTranslation.Response]] = [:]

    public init(
        data: Collection,
        @ViewBuilder cellBuilder: @escaping (Collection.Element, _ translations: [FeatureTranslation.Response])
            -> CellView,
        @ViewBuilder headerBuilder: @escaping () -> HeaderView
    ) {
        self.data = data
        self.cellBuilder = cellBuilder
        self.headerBuilder = headerBuilder
    }

    public var body: some View {
        contentView
    }

    @ViewBuilder
    private var contentView: some View {
        List {
            headerBuilder()

            ForEach(data) { element in
                makeCell(element)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
        .background(listBgColor)
        .scrollContentBackground(.hidden)
        .modifier {
            if #available(iOS 18.0, macOS 15.0, *) {
                #if canImport(Translation) && (os(macOS) || os(iOS))
                    $0
                        .safeAreaInset(edge: .bottom) {
                            bottomSafeAreaView
                        }
                #else
                    $0
                #endif
            } else {
                $0
            }
        }
    }

    #if canImport(Translation) && (os(macOS) || os(iOS))
        @available(iOS 18.0, macOS 15.0, *)
        private var bottomSafeAreaView: some View {
            TranslationView(data as! [any TranslatableFeature]) { responses in
                for response in responses {
                    guard
                        let components = response.clientIdentifier?.components(separatedBy: "|"),
                        let itemID = components.first,
                        components.count > 1
                    else {
                        return
                    }

                    if translations[itemID] == nil {
                        translations[itemID] = [response]
                    } else {
                        translations[itemID]?.append(response)
                    }
                }
            }
        }
    #endif

    private func makeCell(_ element: Collection.Element) -> some View {
        cellBuilder(element, translations[element.id, default: []])
            .padding()
            .background(cellBgColor)
            .cornerRadius(10)
    }

    private var cellBgColor: Color {
        #if os(macOS)
            Color(NSColor.controlBackgroundColor)
        #else
            Color(UIColor.secondarySystemGroupedBackground)
        #endif
    }

    private var listBgColor: Color {
        #if os(macOS)
            Color(NSColor.windowBackgroundColor)
        #else
            Color(UIColor.systemGroupedBackground)
        #endif
    }
}

public extension FeatureUpvoteView {
    struct Config {}
}

// MARK: - Previews

public struct FeatureUpvoteView_Previews: PreviewProvider {
    public static let data: [Feature] = [
        Feature(
            id: "1",
            name: "Asana integration",
            description: "Please make an integration with Asana.",
            tag: "Open",
            voteCount: 0
        ),
        Feature(
            id: "2",
            name: "Matching game",
            description: "Get faster at matching terms",
            tag: "Open",
            voteCount: 0
        ),
        Feature(
            id: "3",
            name: "Dictionary Suggestion",
            description: "Add dictionary suggestions when writing vocabulary",
            tag: "In Progress",
            voteCount: 1
        ),
    ]

    public static let tagColorMap = [
        "Open": Color.accentColor,
        "In Progress": Color.orange,
        "Done": Color.purple,
        "Closed": Color.gray,
    ]

    @State static var tags: Set<String> = []
    static var allTags: [String] {
        return Array(Set(data.map(\.tag)))
    }

    private static var filterdData: [Feature] {
        if tags.isEmpty {
            return data
        } else {
            return data.filter { tags.contains($0.tag) }
        }
    }

    public static var previews: some View {
        NavigationView {
            FeatureUpvoteView(data: filterdData) { feature, translations in
                FeatureCellView(
                    title: feature.name,
                    description: translations.first?.targetText ?? feature.description,
                    tag: feature.tag
                ) {
                    VoteButton(voteCount: feature.voteCount, hasVoted: false)
                }
                .tagColorMap(tagColorMap)
            } headerBuilder: {
                TagFilterView(tags: allTags, selectedTags: $tags)
                    .tagColorMap(tagColorMap)
            }
            .searchable(text: .constant(""))
            .navigationTitle(Text("Features"))
        }
    }
}
