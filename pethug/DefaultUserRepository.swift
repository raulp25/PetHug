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
    
    func registerUser(user: User) async throws -> Result<Bool, Error> {
        let result = try await userDataSource.registerUser(user: user)
        switch result {
        case .success(let bool):
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
        
    }
}
