//
//  MessengerError.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

/// Default error.
enum PetsError: Error, LocalizedError {
    case `default`(_ error: Error)
    case defaultCustom(_ string: String)
    case someThingWentWrong

    var errorDescription: String? {
        switch self {
        case let .default(err):
            return err.localizedDescription

        case .someThingWentWrong:
            return NSLocalizedString("Something went wrong.", comment: "")

        case let .defaultCustom(customErrorString):
            return NSLocalizedString(customErrorString, comment: "")
        }
    }
}

