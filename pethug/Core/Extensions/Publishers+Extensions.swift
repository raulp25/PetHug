//
//  Publishers.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//

import Combine
import FirebaseAuth

// MARK: - Custom validation operator
extension Publisher where Self.Output == String, Failure == Never {
    func validateText(validationType: ValidatorType) -> AnyPublisher<ValidationState, Never> {
        let validator = ValidatorFactory.validateForType(type: validationType)
        return validator.validate(publisher: self.eraseToAnyPublisher())
    }
}

// MARK: - Custom string validation operators
extension Publisher where Output == String {
    func isEmpty() -> Publishers.Map<Self, Bool> {
        map { $0.isEmpty }
    }

    func isWithNumbers() -> Publishers.Map<Self, Bool> {
        map { $0.hasNumbers() }
    }

    func isWithSpecialChars() -> Publishers.Map<Self, Bool> {
        map { $0.hasSpecialCharacters() }
    }
}


// MARK: - handleThreads (subscibe to background and receive on main)
extension Publisher {
    func handleThreadsOperator() -> AnyPublisher<Self.Output, Self.Failure> {
        self
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
