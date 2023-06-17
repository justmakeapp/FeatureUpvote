//
//  Created by Long Vu on 27/04/2022.
//

import Foundation

public extension L10n {
    static func localizedString(
        _ key: String,
        tableName: String? = nil,
        value: String = "",
        comment: String = ""
    ) -> String {
        return NSLocalizedString(
            key,
            tableName: tableName,
            bundle: .module,
            value: value,
            comment: comment
        )
    }
}
