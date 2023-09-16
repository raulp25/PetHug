//
//  UserRepository.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation

protocol UserRepository {
    
    func registerUser(user: User) async throws -> Result<Bool, Error>
}
