//
//  Validator.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import Foundation

protocol Validator {
    func validateText(
        validationType: ValidatorType,
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never>
}

extension Validator {
    func validateText(
        validationType: ValidatorType,
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        let validator = ValidatorFactory.validateForType(type: validationType)
        return validator.validate(publisher: publisher)
    }
}


