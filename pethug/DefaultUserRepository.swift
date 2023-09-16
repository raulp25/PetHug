//
//  DefaultUserRepository.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    private let userDataSource: UserDataSource
    
    init(userDataSource: UserDataSource) {
        self.userDataSource = userDataSource
    }
    
    func registerUser(user: User) async throws {
        try await userDataSource.registerUser(user: user)
    }
}
