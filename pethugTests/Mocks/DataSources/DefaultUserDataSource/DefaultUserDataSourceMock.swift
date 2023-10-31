//
//  DefaultUserDataSourceMock.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import Foundation

@testable import pethug

//MARK: - Successfull Mock
final class DefaultUserDataSourceSuccessMock: UserDataSource {
    //MARK: - Register
    func registerUser(user: User) async throws { }
    
    //MARK: - Get
    func fetchUser() async throws -> User {
        return User(id: "userMockId",
                    username: "Neo",
                    email: "fakeEmail@gmail.com",
                    bio: nil,
                    profileImageUrl: "https://www.fake-url.com/2230s-s")
    }
    
    //MARK: - Update
    func updateUser(imageUrl: String) async throws { }
    
    //MARK: - Delete
    func deleteUser() async throws { }
    
}

//MARK: - Failure Mock
final class DefaultUserDataSourceFailureMock: UserDataSource {
    //MARK: - Register
    func registerUser(user: User) async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Get
    func fetchUser() async throws -> User {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Update
    func updateUser(imageUrl: String) async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Delete
    func deleteUser() async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
}
