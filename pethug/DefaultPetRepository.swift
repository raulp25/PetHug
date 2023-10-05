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
    
    func fetchUserPets() async throws -> [Pet] {
        let pets = try await petDataSource.fetchUserPets()
        
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
    
}
