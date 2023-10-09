//
//  FilterPetsViewModel+Types.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import Foundation

extension FilterPetsViewModel {
    enum State {
        case valid
        case invalid
    }

    enum LoadingState {
        case loading
        case success
        case error(PetsError)
    }

}

