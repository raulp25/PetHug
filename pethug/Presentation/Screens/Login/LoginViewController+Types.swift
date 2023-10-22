//
//  LoginViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 21/10/23.
//

import Foundation

extension LoginViewModel {
    enum State {
        case loading
        case success
        case error(PetsError)
        case networkError
    }
    
}
