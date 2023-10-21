//
//  UpdateUserUC.swift
//  pethug
//
//  Created by Raul Pena on 20/10/23.
//

import Foundation

// MARK: - Protocol -
protocol UpdateUserUC {
    func execute(imageUrl: String) async throws
}

// MARK: - Implementation -
class DefaultUpdateUserUC: UpdateUserUC {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(imageUrl: String) async throws {
        try await userRepository.updateUser(imageUrl: imageUrl)
    }
}


protocol ComposeUpdateUserUC {
    static func composeUpdateUserUC() -> DefaultUpdateUserUC
}

struct UpdateUser: ComposeUpdateUserUC {
    static func composeUpdateUserUC() -> DefaultUpdateUserUC {
        DefaultUpdateUserUC(userRepository: DefaultUserRepository(userDataSource: DefaultUserDataSource()))
    }
}


