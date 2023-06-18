//
//  File.swift
//
//
//  Created by Long Vu on 18/06/2023.
//

import Foundation

extension CGFloat {
    func scaledToMacCatalyst() -> CGFloat {
        #if targetEnvironment(macCatalyst)
            return ceil(self * 0.765)
        #else
            return self
        #endif
    }
}

extension Int {
    func scaledToMacCatalyst() -> Int {
        #if targetEnvironment(macCatalyst)
            return Int(ceil(Double(self) * 0.765))
        #else
            return self
        #endif
    }
}

extension Double {
    func scaledToMacCatalyst() -> Double {
        #if targetEnvironment(macCatalyst)
            return ceil(self * 0.765)
        #else
            return self
        #endif
    }
}
