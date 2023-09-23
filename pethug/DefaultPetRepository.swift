//
//  DefaultPetsRepository.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

final class DefaultPetRepository: PetRepository {
    private let petDataSource: PetDataSource
    
    init(petDataSource: PetDataSource) {
        self.petDataSource = petDataSource
    }
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet] {
        let pets = try await petDataSource.fetchPets(fetchCollection: path)
        
        return pets
    }
    
    
}
