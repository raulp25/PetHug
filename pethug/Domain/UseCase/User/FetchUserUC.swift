//
//  FetchUserUC.swift
//  pethug
//
//  Created by Raul Pena on 16/10/23.
//

import Foundation

// MARK: - Protocol -
protocol FetchUserUC {
    func execute() async throws -> User
}

// MARK: - Implementation -
class DefaultFetchUserUC: FetchUserUC {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute() async throws -> User {
        let user  = try await userRepository.fetchUser()
        return user
    }
}


protocol ComposeFetchUserUC {
    static func composeFetchUserUC() -> DefaultFetchUserUC
}

struct FetchUser: ComposeFetchUserUC {
    static func composeFetchUserUC() -> DefaultFetchUserUC {
        DefaultFetchUserUC(userRepository: DefaultUserRepository(userDataSource: DefaultUserDataSource()))
    }
}

