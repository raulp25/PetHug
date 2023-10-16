//
//  FetchPetsUC.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
//MARK: - Protocol
protocol FetchPetsUC {
    func execute(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet]
}


//MARK: - Implementation
final class DefaultFetchPetsUC: FetchPetsUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petRepository.fetchPets(fetchCollection: path, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
}


protocol ComposeFetchPetsUC {
    static func composeFetchPetsUC() -> DefaultFetchPetsUC
}

struct FetchPets: ComposeFetchPetsUC {
    static func composeFetchPetsUC() -> DefaultFetchPetsUC {
        DefaultFetchPetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}

