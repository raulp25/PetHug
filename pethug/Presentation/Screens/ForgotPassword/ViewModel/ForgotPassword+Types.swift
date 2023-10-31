//
//  ForgotPassword+Types.swift
//  pethug
//
//  Created by Raul Pena on 21/10/23.
//

extension ForgotPasswordViewModel {
    enum State: Equatable {
        case loading
        case success
        case error(PetsError)
        case networkError
    }   
}
