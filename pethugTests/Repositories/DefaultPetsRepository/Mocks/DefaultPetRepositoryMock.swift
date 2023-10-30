//
//  DefaultFetchAllPetsUCMock.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import Foundation
@testable import pethug

final class DefaultPetRepositorySuccessMock: PetRepository {
    
    private let petDataSource: PetDataSource
    
    init(petDataSource: PetDataSource) {
        self.petDataSource = petDataSource
    }
    
    
    func fetchAllPets(resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchAllPets(resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchAllPets(withFilter: options, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchPets(fetchCollection: path, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchUserPets(with: resetPagination)
        
        return pets
    }
    
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchPets(collection: collection, withFilter: options, resetFilterQueries: resetFilterQueries)
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
    
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool {
        let result = try await petDataSource.updatePet(data: data, oldCollection: oldCollection)
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

final class DefaultPetRepositoryFailureMock: PetRepository {
    
    private let petDataSource: PetDataSource
    
    init(petDataSource: PetDataSource) {
        self.petDataSource = petDataSource
    }
    
    
    func fetchAllPets(resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchAllPets(resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchAllPets(withFilter: options, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchPets(fetchCollection: path, resetFilterQueries: resetFilterQueries)
        
        return pets
    }
    
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchUserPets(with: resetPagination)
        
        return pets
    }
    
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = try await petDataSource.fetchPets(collection: collection, withFilter: options, resetFilterQueries: resetFilterQueries)
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
    
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool {
        let result = try await petDataSource.updatePet(data: data, oldCollection: oldCollection)
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
