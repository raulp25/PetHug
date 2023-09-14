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
        case error(MessengerError)
    }
    
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(email: String?, password: String?) async {
        guard let email, let password else {
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
