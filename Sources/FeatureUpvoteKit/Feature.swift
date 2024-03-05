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
}
