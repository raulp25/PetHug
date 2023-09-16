//
//  RegisterUserUC.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation

// MARK: - Protocol -

protocol RegisterUserUC {
    func execute(user: User) async throws -> Result<Bool, Error>
}

// MARK: - Implementation -

class DefaultRegisterUserUC: RegisterUserUC {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(user: User) async throws -> Result<Bool, Error> {
        let result = try await userRepository.registerUser(user: user)
        switch result {
        case .success(_):
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}
