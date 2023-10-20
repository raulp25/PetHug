//
//  FilterAllPetsUC.swift
//  pethug
//
//  Created by Raul Pena on 20/10/23.
//

import Foundation
//MARK: - Protocol
protocol FilterAllPetsUC {
    func execute(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet]
}


//MARK: - Implementation
final class DefaultFilterAllPetsUC: FilterAllPetsUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petRepository.fetchAllPets(withFilter: options, resetFilterQueries: resetFilterQueries)
        return pets
    }
}


protocol ComposeFilterAllPetsUC {
    static func composeFilterAllPetsUC() -> DefaultFilterAllPetsUC
}

struct FilterAllPets: ComposeFilterAllPetsUC {
    static func composeFilterAllPetsUC() -> DefaultFilterAllPetsUC {
        DefaultFilterAllPetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


