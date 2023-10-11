//
//  FetchUserPetsUC.swift
//  pethug
//
//  Created by Raul Pena on 05/10/23.
//

import Foundation
//MARK: - Protocol
protocol FetchUserPetsUC {
    func execute(with resetPagination: Bool) async throws -> [Pet]
}


//MARK: - Implementation
final class DefaultFetchUserPetsUC: FetchUserPetsUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(with resetPagination: Bool = false) async throws -> [Pet] {
        let pets = try await petRepository.fetchUserPets(with: resetPagination)
        
        return pets
    }
}


protocol ComposeFetchUserPetsUC {
    static func composeFetchUserPetsUC() -> DefaultFetchUserPetsUC
}

struct FetchUserPets: ComposeFetchUserPetsUC {
    static func composeFetchUserPetsUC() -> DefaultFetchUserPetsUC {
        DefaultFetchUserPetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}

