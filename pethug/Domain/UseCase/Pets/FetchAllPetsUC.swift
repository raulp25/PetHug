//
//  FetchAllPetsUC.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import Foundation
//MARK: - Protocol
protocol FetchAllPetsUC {
    func execute(resetFilterQueries: Bool) async throws -> [Pet]
}


//MARK: - Implementation
final class DefaultFetchAllPetsUC: FetchAllPetsUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petRepository.fetchAllPets(resetFilterQueries: resetFilterQueries)
        
        return pets
    }
}


protocol ComposeFetchAllPetsUC {
    static func composeFetchAllPetsUC() -> DefaultFetchAllPetsUC
}

struct FetchAllPets: ComposeFetchAllPetsUC {
    static func composeFetchAllPetsUC() -> DefaultFetchAllPetsUC {
        DefaultFetchAllPetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


