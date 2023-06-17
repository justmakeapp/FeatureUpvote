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

public struct FeatureUpvoteView<
    Collection: RandomAccessCollection,
    CellView: View,
    HeaderView: View
>: View where Collection.Element: Hashable {
    private var data: Collection
    private var cellBuilder: (Collection.Element) -> CellView
    private var headerBuilder: () -> HeaderView

    private var config = Config()

    public init(
        data: Collection,
        @ViewBuilder cellBuilder: @escaping (Collection.Element) -> CellView,
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
        let list = List {
            headerBuilder()

            ForEach(data, id: \.self) { element in
                if #available(macOS 13.0, iOS 16.0, *) {
                    makeCell(element)
                        .listRowSeparator(.hidden)
                } else {
                    makeCell(element)
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .background(listBgColor)

        if #available(macOS 13.0, iOS 16.0, *) {
            list
                .scrollContentBackground(.hidden)
        } else {
            list
        }
    }

    private func makeCell(_ element: Collection.Element) -> some View {
        cellBuilder(element)
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
            FeatureUpvoteView(data: filterdData) { feature in
                FeatureCellView(
                    title: feature.name,
                    description: feature.description,
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
