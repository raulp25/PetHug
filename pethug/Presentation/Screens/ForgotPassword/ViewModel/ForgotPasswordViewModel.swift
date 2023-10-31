//
//  ForgotPasswordViewModel.swift
//  pethug
//
//  Created by Raul Pena on 17/10/23.
//

import Combine
import UIKit

struct ForgotPasswordViewModel {
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func resetPasswordWith(email: String) async {
        state.send(.loading)
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                state.send(.networkError)
                return
            }
            
            try await authService.resetPassword(withEmail: email) //Reset password
            state.send(.success)
        } catch {
            state.send(.error(.default(error)))
        }
    }
}
