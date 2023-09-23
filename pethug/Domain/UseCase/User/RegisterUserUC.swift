//
//  RegisterUserUC.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation

// MARK: - Protocol -
protocol RegisterUserUC {
    func execute(user: User) async throws
}

// MARK: - Implementation -
class DefaultRegisterUserUC: RegisterUserUC {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(user: User) async throws  {
        try await userRepository.registerUser(user: user)
    }
}


protocol ComposeRegisterUserUC {
    static func composeRegisterUserUC() -> DefaultRegisterUserUC
}

struct RegisterUser: ComposeRegisterUserUC {
    static func composeRegisterUserUC() -> DefaultRegisterUserUC {
        DefaultRegisterUserUC(userRepository: DefaultUserRepository(userDataSource: DefaultUserDataSource()))
    }
}
