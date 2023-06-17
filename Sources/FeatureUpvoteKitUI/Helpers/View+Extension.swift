//
//  View+Extension.swift
//
//
//  Created by Long Vu on 17/06/2023.
//

import SwiftUI

public extension View {
    func then(_ body: (inout Self) -> Void) -> Self {
        var result = self

        body(&result)

        return result
    }
}
