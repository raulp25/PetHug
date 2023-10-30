//
//  NewPetViewModel+Types.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import Foundation

extension NewPetViewModel {
    enum State {
        case valid
        case invalid
    }

    enum LoadingState: Equatable {
        case loading
        case success
        case error(PetsError)
        case networkError
    }

}
