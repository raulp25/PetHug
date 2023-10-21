//
//  Validatable.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

// MARK: - Validatable
protocol Validatable {
    func validate(publisher: AnyPublisher<String, Never>) -> AnyPublisher<ValidationState, Never>
}

// MARK: - Validation Publishers
extension Validatable {
    func isEmpty(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .isEmpty()
            .eraseToAnyPublisher()
    }

    func isToShort(with publisher: AnyPublisher<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map { !($0.count >= count) }
            .eraseToAnyPublisher()
    }
    
    func isToLong(with publisher: AnyPublisher<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map { ($0.count >= count) }
            .eraseToAnyPublisher()
    }

    func hasNumbers(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .isWithNumbers()
            .eraseToAnyPublisher()
    }

    func hasLetters(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.contains(where: { $0.isLetter }) }
            .eraseToAnyPublisher()
    }

    func hasSpecialChars(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .isWithSpecialChars()
            .eraseToAnyPublisher()
    }

    func isEmail(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.isValidEmail() }
            .eraseToAnyPublisher()
    }

    func isPhoneNumber(with publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.isPhoneNumValid() }
            .eraseToAnyPublisher()
    }
}

// MARK: - Custom Validations
struct EmailValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest(
            isEmpty(with: publisher),
            isEmail(with: publisher)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, isEmail in
            if isEmpty { return .error(.empty) }
            if !isEmail { return .error(.invalidEmail) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}

struct PhoneValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest(
            isEmpty(with: publisher),
            isPhoneNumber(with: publisher)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, isPhoneNum in
            if isEmpty { return .error(.empty) }
            if !isPhoneNum { return .error(.invalidPhoneNum) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}

struct NewAccountPasswordValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest4(
            isEmpty(with: publisher),
            isToShort(with: publisher, count: 6),
            hasLetters(with: publisher),
            hasSpecialChars(with: publisher)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, toShort, hasLetters, hasSpecialChars  in
            if isEmpty { return .error(.empty) }
            if toShort { return .error(.toShortPassword) }
            if !hasLetters { return .error(.passwordNeedsLetters) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}

struct PasswordValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        publisher
        .map { input in
            return input.isEmpty ? .error(.empty) : .valid
        }
        .eraseToAnyPublisher()
    }
}


struct NameValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest4(
            isEmpty(with: publisher),
            isToShort(with: publisher, count: 2),
            isToLong(with: publisher, count: 12),
            hasSpecialChars(with: publisher)
        ).removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, toShort, toLong, hasSpecialChars in
            if isEmpty { return .error(.empty) }
            if toShort { return .error(.toShortName) }
            if toLong  { return .error(.toLongName) }
            if hasSpecialChars { return .error(.nameCantHaveNumOrSpecialChars) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}

