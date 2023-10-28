//
//  DefaultFetchAllPetsUCMock.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import Foundation
@testable import pethug

final class DefaultPetRepositoryMock: PetRepository {
    
    func fetchAllPets(resetFilterQueries: Bool) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = [Pet]()
        
        return pets
    }
    
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = [Pet]()
        
        return pets
    }
    
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let pets = [Pet]()
        
        return pets
    }
    
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets = [Pet]()
        return pets
    }
    
    func fetchFavoritePets() async throws -> [Pet] {
        let pets = [Pet]()
        
        return pets
    }
    
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        let result = true
        return result
    }
    
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool {
        let result = true
        return result
    }
    
    func deletePet(collection path: String, docId: String) async throws -> Bool {
        let result = true
        return result
    }
    
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool {
        let result = true
        return result
    }
    
    func likePet(data: Pet) async throws {
            
    }
    
    func dislikePet(data: Pet) async throws {
            
    }
    
}
