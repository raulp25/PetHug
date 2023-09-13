//
//  LoginUC.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//

import Foundation

protocol FirebseLoginUC {
    func signIn(email: String, password: String) async throws
}

// MARK: - Implementation -

class FirebaseLoginUC: FirebseLoginUC {
    
    private let firebaseAuthRepository: FirebaseAuthRepository
    
    init(firebaseAuthRepository: FirebaseAuthRepository) {
        self.firebaseAuthRepository = firebaseAuthRepository
    }
    
    func signIn(email: String, password: String) async throws {
        try await firebaseAuthRepository.signIn(email: email, password: password)
    }
}
