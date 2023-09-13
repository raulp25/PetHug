//
//  DefaultFirebaseAuthRespository.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//
import Combine
import FirebaseAuth

final class DefaultFirebaseAuthRepository: FirebaseAuthRepository{
    // MARK: - Create Account
    func createAccounWith(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await result.user.sendEmailVerification()
        return result.user.uid
    }

    // MARK: - Update Account
    func updateAuthDisplayName(uid _: String, name: String) async throws {
        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.displayName = name
        try await change?.commitChanges()
        try await Auth.auth().currentUser?.reload()
    }

    // MARK: - SigIn
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    // MARK: - SignOut
    func signOut() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Reload
    func reloadUser() async throws {
        try await Auth.auth().currentUser?.reload()
    }

    // MARK: - Observe
    func observeAuthChanges() -> AnyPublisher<SessionState, Never> {
        return Publishers.AuthPublisher().eraseToAnyPublisher()
    }
}

//Add AuthManager
