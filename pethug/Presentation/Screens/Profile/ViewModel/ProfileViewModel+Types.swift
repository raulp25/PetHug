//
//  ProfileViewModel+Types.swift
//  pethug
//
//  Created by Raul Pena on 20/10/23.
//

import UIKit

extension ProfileViewModel {
    enum State {
        case loading
        case loaded
        case error(PetsError)
        case deleteUserError
        case networkError
    }
    
}


