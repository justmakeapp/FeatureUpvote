//
//  Catalyst+Extension.swift
//
//
//  Created by Long Vu on 18/06/2023.
//

import Foundation

extension CGFloat {
    func scaledToMac() -> CGFloat {
        #if targetEnvironment(macCatalyst) || os(macOS)
            return ceil(self * 0.765)
        #else
            return self
        #endif
    }
}

extension Int {
    func scaledToMac() -> Int {
        #if targetEnvironment(macCatalyst) || os(macOS)
            return Int(ceil(Double(self) * 0.765))
        #else
            return self
        #endif
    }
}

extension Double {
    func scaledToMac() -> Double {
        #if targetEnvironment(macCatalyst) || os(macOS)
            return ceil(self * 0.765)
        #else
            return self
        #endif
    }
}
