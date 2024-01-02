//
//  TagView.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import SwiftUI

public struct TagView: View {
    private let title: String
    private var config = Config()
    @State private var isSelected: Bool

    public init(title: String, isSelected: Bool = false) {
        self.title = title
        _isSelected = .init(initialValue: isSelected)
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        Button {
            guard !config.disabled else {
                return
            }
            withAnimation {
                isSelected.toggle()
            }

            config.valueChanged(isSelected)
        } label: {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .accentColor)
            }
            .padding(.vertical, 4)
            .padding(.horizontal)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background {
            ZStack {
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color.accentColor.opacity(0.1))
                Capsule()
                    .stroke(Color.accentColor, lineWidth: 1)
            }
        }
    }
}

public extension TagView {
    struct Config {
        var valueChanged: (Bool) -> Void = { _ in }
        var disabled = false
    }

    func valueChanged(_ value: @escaping (Bool) -> Void) -> Self {
        then { $0.config.valueChanged = value }
    }

    func disabled() -> Self {
        then { $0.config.disabled = true }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TagView(title: "Open")

            TagView(title: "Open", isSelected: true)

            TagView(title: "In Progress")
                .accentColor(.green)

            TagView(title: "In Progress", isSelected: true)
                .accentColor(.green)
        }
    }
}
