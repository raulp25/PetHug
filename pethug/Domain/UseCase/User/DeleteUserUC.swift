//
//  DeleteUserUC.swift
//  pethug
//
//  Created by Raul Pena on 21/10/23.
//

import Foundation

// MARK: - Protocol -
protocol DeleteUserUC {
    func execute() async throws
}

// MARK: - Implementation -
class DefaultDeleteUserUC: DeleteUserUC {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute() async throws  {
        try await userRepository.deleteUser()
    }
}


protocol ComposeDeleteUserUC {
    static func composeDeleteUserUC() -> DefaultDeleteUserUC
}

struct DeleteUser: ComposeDeleteUserUC {
    static func composeDeleteUserUC() -> DefaultDeleteUserUC {
        DefaultDeleteUserUC(userRepository: DefaultUserRepository(userDataSource: DefaultUserDataSource()))
    }
}
