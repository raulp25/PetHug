//
//  PetsRepository.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

protocol PetRepository {
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet]
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet]
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet]
    func fetchFavoritePets() async throws -> [Pet]
    
    func createPet(collection path: String, data: Pet) async throws -> Bool
    func updatePet(collection path: String, data: Pet) async throws -> Bool
    func deletePet(collection path: String, docId: String) async throws -> Bool
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool
    
    func likePet(data: Pet) async throws
    func dislikePet(data: Pet) async throws
}
