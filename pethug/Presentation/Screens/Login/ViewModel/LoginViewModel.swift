//
//  LoginViewModel.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

struct LoginViewModel {
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(email: String?, password: String?) async {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = password?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            state.send(.error(.someThingWentWrong))
            return
        }
        state.send(.loading)
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            try await authService.signIn(email: email, password: password) //Login
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    
}
