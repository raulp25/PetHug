//
//  MessengerError.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

/// Default error.
enum PetsError: Error, LocalizedError, Equatable {
    static func == (lhs: PetsError, rhs: PetsError) -> Bool {
            switch (lhs, rhs) {
            case (.default(let lhsError), .default(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.defaultCustom(let lhsString), .defaultCustom(let rhsString)):
                return lhsString == rhsString
            case (.someThingWentWrong, .someThingWentWrong):
                return true
            default:
                return false
            }
        }
    
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

