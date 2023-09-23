//
//  UseCaseFactory.swift
//  pethug
//
//  Created by Raul Pena on 20/09/23.
//

import Foundation

enum UseCaseFactory {
    case user
    case pet
    
    ///Mejor hacer funciones por cada use case en domain o algo asi
    
    var getUC: Any {
        switch self {
        case .user:
            return DefaultRegisterUserUC(userRepository: DefaultUserRepository(userDataSource: DefaultUserDataSource()))
        case .pet:
            return DefaultFetchPetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
        }
    }
}
