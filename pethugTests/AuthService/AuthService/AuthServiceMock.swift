//
//  AuthServiceMock.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import Foundation
import Combine

@testable import pethug

final class AuthServiceMock: AuthServiceProtocol {
    var uid: String = "mock-uid-90"
    // MARK: - Create Account
    func createAccounWith(email: String, password: String) async throws -> String {
        return uid
    }

    // MARK: - Update Account
    func updateAuthDisplayName(uid _: String, name: String) async throws {
    }

    // MARK: - SigIn
    func signIn(email: String, password: String) async throws {
    }

    // MARK: - SignOut
    func signOut() throws {
    }

    // MARK: - Reload
    func reloadUser() async throws {
    }

    // MARK: - Observe
    func observeAuthChanges() -> AnyPublisher<SessionState, Never> {
        return Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    //MARK: - Reset Password
    func resetPassword(withEmail email: String) async throws {
    }
}
