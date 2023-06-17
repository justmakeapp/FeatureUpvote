//
//  Feature.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import Foundation

public struct Feature: Hashable, Decodable {
    public let id: String
    public let name: String
    public let description: String
    public let tag: String
    public let voteCount: UInt

    public init(id: String, name: String, description: String, tag: String, voteCount: UInt) {
        self.id = id
        self.name = name
        self.description = description
        self.tag = tag
        self.voteCount = voteCount
    }
}
