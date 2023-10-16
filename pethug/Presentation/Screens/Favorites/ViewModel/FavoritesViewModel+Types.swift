//
//  FavoritesViewModel+Types.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import Foundation

extension FavoritesViewModel {
    enum Event: Equatable {
        case updatedPets([Pet])
        case emptyPets
    }
    
    enum Action {
        case tapRow(Pet)
    }
    
    enum State: Equatable {
        private var value: String? {
            return String(describing: self).components(separatedBy: "(").first
        }
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.value == rhs.value
        }
        
        case loading
        case loaded([Pet])
        case error(PetsError)
    }
    
}

