//
//  ForgotPasswordViewModel.swift
//  pethug
//
//  Created by Raul Pena on 17/10/23.
//

import Combine
import UIKit

struct ForgotPasswordViewModel {
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
    
    func resetPasswordWith(email: String) async {
        state.send(.loading)
        do {
            try await authService.resetPassword(withEmail: email)
            state.send(.success)
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    
}
