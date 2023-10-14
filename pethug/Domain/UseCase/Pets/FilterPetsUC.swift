//
//  FilterPetsUC.swift
//  pethug
//
//  Created by Raul Pena on 13/10/23.
//


import Foundation
//MARK: - Protocol
protocol FilterPetsUC {
    func execute(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet]
}


//MARK: - Implementation
final class DefaultFilterPetsUC: FilterPetsUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petRepository.fetchPetsWithFilter(options: options, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
}


protocol ComposeFilterPetsUC {
    static func composeFilterPetsUC() -> DefaultFilterPetsUC
}

struct FilterPets: ComposeFilterPetsUC {
    static func composeFilterPetsUC() -> DefaultFilterPetsUC {
        DefaultFilterPetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}

