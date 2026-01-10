//
//  TagFilterView.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import SwiftUI

public struct TagFilterView: View {
    private let tags: [String]
    @Binding private var selectedTags: Set<String>
    private var config = Config()

    public init(tags: [String], selectedTags: Binding<Set<String>>) {
        self.tags = tags
        _selectedTags = selectedTags
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tags, id: \.self) { tag in
                    TagView(title: tag)
                        .valueChanged { isSelected in
                            withAnimation {
                                if isSelected {
                                    selectedTags.insert(tag)
                                } else {
                                    selectedTags.remove(tag)
                                }
                            }
                        }
                        .tint(config.tagColorMap[tag])
                }
            }
            .padding(4)
        }
        .scrollIndicators(.hidden)
        .listRowBackground(Color.clear)
    }
}

public extension TagFilterView {
    struct Config {
        var tagColorMap: [String: Color] = [:]
    }

    func tagColorMap(_ value: [String: Color]) -> Self {
        then { $0.config.tagColorMap = value }
    }
}

struct TagFilterView_Previews: PreviewProvider {
    static var previews: some View {
        TagFilterView(tags: [], selectedTags: .constant(.init()))
    }
}
