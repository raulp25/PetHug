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
    
    func fetchUser() async throws -> User {
        let user = try await userDataSource.fetchUser()
        
        return user
    }
    
    func updateUser(imageUrl: String) async throws {
        try await userDataSource.updateUser(imageUrl: imageUrl)
    }
    
    func deleteUser() async throws {
        try await userDataSource.deleteUser()
    }
}
