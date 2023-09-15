//
//  CreateAccountViewModel.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import UIKit
import Combine

struct CreateAcoountViewModel {
    enum State {
        case loading
        case success
        case error(MessengerError)
    }
    
    var profileImage: UIImage?
    
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
//    func k() {
//        state.send(.loading)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:{
//            state.send(.success)
//        })
//    }
    
    func crateAccount(username: String, email: String?, password: String?) async {
        guard let email, let password else {
            state.send(.error(.someThingWentWrong))
            return
        }
        state.send(.loading)
        do {
//            en el imageservice poner ahi la condicion de que la image no sea nil 
            try await authService.createAccounWith(email: email, password: password)
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    
}

