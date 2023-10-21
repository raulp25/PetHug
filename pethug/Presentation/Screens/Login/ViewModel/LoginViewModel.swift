//
//  LoginViewModel.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

struct LoginViewModel {
    enum State {
        case loading
        case success
        case error(PetsError)
    }
    
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
            try await authService.signIn(email: email, password: password)
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    
}
