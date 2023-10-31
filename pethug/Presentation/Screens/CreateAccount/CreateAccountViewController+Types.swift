//
//  CreateAccountViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 22/10/23.
//

import Foundation

extension CreateAccountViewModel {
    enum State: Equatable {
        case loading
        case success
        case error(PetsError)
        case networkError
    }
}
