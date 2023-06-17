//
//  ContentView.swift
//  FeatureUpvoteExample
//
//  Created by Long Vu on 17/06/2023.
//

import FeatureUpvoteKit
import FeatureUpvoteKitUI
import SwiftUI

struct ContentView: View {
    @State private var isShowFeatureUpvoteView = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            Button {
                isShowFeatureUpvoteView.toggle()
            } label: {
                Text("Vote on Features")
            }
        }
        .padding()
        .sheet(isPresented: $isShowFeatureUpvoteView) {
            MyFeatureUpvoteView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyFeatureUpvoteView: View {
    @State var search = ""
    @State var tags: Set<String> = []
    var allTags: [String] {
        return Array(Set(data.map(\.tag))).sorted()
    }

    var filterdData: [Feature] {
        var result: [Feature] = data
        if !tags.isEmpty {
            result = data.filter { tags.contains($0.tag) }
        }
        if !search.isEmpty {
            result = result.filter { feature in
                let sample = [feature.name, feature.description].joined(separator: " ")
                return sample.lowercased().contains(search.lowercased())
            }
        }

        return result
    }

    let data: [Feature] = FeatureUpvoteView_Previews.data

    var body: some View {
        NavigationView {
            FeatureUpvoteView(data: filterdData) { feature in
                FeatureCellView(
                    title: feature.name,
                    description: feature.description,
                    tag: feature.tag
                ) {
                    VoteButton(voteCount: feature.voteCount, hasVoted: false)
                }
                .tagColorMap(FeatureUpvoteView_Previews.tagColorMap)
            } headerBuilder: {
                TagFilterView(tags: allTags, selectedTags: $tags)
                    .tagColorMap(FeatureUpvoteView_Previews.tagColorMap)
            }
            .searchable(text: $search)
            .navigationTitle(Text("Features"))
            #if os(iOS)
                .navigationViewStyle(.stack)
            #endif
        }
    }
}
