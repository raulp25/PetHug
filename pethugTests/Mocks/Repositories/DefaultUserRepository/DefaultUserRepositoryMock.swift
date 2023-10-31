//
//  DefaultUserRepositoryMock.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import Foundation

@testable import pethug

//MARK: - Success Mock

final class DefaultUserRepositorySuccessMock: UserRepository {
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

//MARK: - Failure Mock

final class DefaultUserRepositoryFailureMock: UserRepository {
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

