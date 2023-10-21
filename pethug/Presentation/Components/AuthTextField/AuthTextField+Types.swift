//
//  AuthTextField+Types.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Foundation

extension AuthTextField {
    enum PlaceholderOption {
        case `default`
        case custom(String)
        case empty
    }

    enum TextFieldType: String {
        case name
        case password
        case newAccountPassword
        case email
        case date

        func defaultPlaceholder() -> String? {
            return "Enter your \(self.rawValue)..."
        }
    }
}
