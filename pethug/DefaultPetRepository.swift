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
    
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchUserPets(with: resetPagination)
        
        return pets
    }
    
    func fetchPetsWithFilter(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchPetsWithFilter(options: options, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchFavoritePets() async throws -> [Pet] {
        let pets = try await petDataSource.fetchFavoritePets()
        
        return pets
    }
    
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        let result = try await petDataSource.createPet(collection: path, data: data)
        return result
    }
    
    func updatePet(collection path: String, data: Pet) async throws -> Bool {
        let result = try await petDataSource.updatePet(collection: path, data: data)
        return result
    }
    
    func deletePet(collection path: String, docId: String) async throws -> Bool {
        let result = try await petDataSource.deletePet(collection: path, docId: docId)
        return result
    }
    
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool {
        let result = try await petDataSource.deletePetFromRepeated(collection: path, docId: docId)
        return result
    }
    
    func likePet(data: Pet) async throws {
            try await petDataSource.likePet(data: data)
    }
    
    func dislikePet(data: Pet) async throws {
            try await petDataSource.dislikePet(data: data)
    }
    
}
