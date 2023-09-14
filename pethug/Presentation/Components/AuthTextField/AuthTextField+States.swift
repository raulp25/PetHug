//
//  AuthTextField+States.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

extension AuthTextField {
    enum FocusState {
        case focused
        case inActive
    }

    enum ErrorState {
        case error
    }

    enum TextState {
        case empty
        case text

        var textFieldScale: CGAffineTransform {
            switch self {
            case .empty:
                return .identity
            case .text:
                return CGAffineTransform(translationX: 0, y: 7.5)
            }
        }
    }
}

