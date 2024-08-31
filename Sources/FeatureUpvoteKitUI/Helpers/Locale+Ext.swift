//
//  Locale+Ext.swift
//  FeatureUpvote
//
//  Created by Long Vu on 31/8/24.
//

import Foundation

extension Locale {
    static var firstPreferredLanguageID: String {
        guard
            let firstPreferredLang = Locale.preferredLanguages.first,
            let languageID = Locale.Components(identifier: firstPreferredLang).languageComponents.languageCode?
            .identifier
        else {
            return Locale.current.language.languageCode?.identifier ?? ""
        }
        return languageID
    }
}
