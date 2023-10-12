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
        case success(FilterOptions)
        case error(PetsError)
    }

    struct FilterOptions {
        var type: Pet.PetType?
        var ageRange: (Int, Int)?
        var address: Pet.State?
        var gender: Pet.Gender?
        var size: Pet.Size?
    }
    
}

