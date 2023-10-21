//
//  ValidatorFactory.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Foundation

// MARK: - Factory
enum ValidatorFactory {
    static func validateForType(type: ValidatorType) -> Validatable {
        switch type {
        case .email:
            return EmailValidator()
        case .phone:
            return PhoneValidator()
        case .password:
            return PasswordValidator()
        case .newAccountPassword:
            return NewAccountPasswordValidator()
        case .name:
            return NameValidator()
        }
    }
}
