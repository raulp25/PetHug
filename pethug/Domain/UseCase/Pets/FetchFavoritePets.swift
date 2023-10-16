//
//  FetchFavoritePets.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import Foundation
//MARK: - Protocol
protocol FetchFavoritePetsUC {
    func execute() async throws -> [Pet]
}


//MARK: - Implementation
final class DefaultFetchFavoritePetsUC: FetchFavoritePetsUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute() async throws -> [Pet] {
        let pets = try await petRepository.fetchFavoritePets()
        
        return pets
    }
}


protocol ComposeFetchFavoritePetsUC {
    static func composeFetchFavoritePetsUC() -> DefaultFetchFavoritePetsUC
}

struct FetchFavoritePets: ComposeFetchFavoritePetsUC {
    static func composeFetchFavoritePetsUC() -> DefaultFetchFavoritePetsUC {
        DefaultFetchFavoritePetsUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


