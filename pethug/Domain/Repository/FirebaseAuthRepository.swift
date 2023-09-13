//
//  FirebaseAuthRepository.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//

import Combine

protocol FirebaseAuthRepository: AnyObject {
    func signOut() throws

    /// Signs in with email and password.
    /// - Parameters:
    ///   - email:
    ///   - password:
    func signIn(email: String, password: String) async throws

    /// Reloads the current user account. Useful if the user has made Auth changes that hasn't taken place.
    func reloadUser() async throws

    /// Creates account with email and password.
    /// - Parameters:
    ///   - email:
    ///   - password:
    /// - Returns: Firebase UID
    func createAccounWith(email: String, password: String) async throws -> String

    /// Listens to the current Auth state of the user and returns the state.
    ///
    ///  - Returns: Publisher with  output ``SessionState`` and failure ``Never``
    func observeAuthChanges() -> AnyPublisher<SessionState, Never>

    func updateAuthDisplayName(uid: String, name: String) async throws
}



