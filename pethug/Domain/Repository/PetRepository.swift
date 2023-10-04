//
//  PetsRepository.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

protocol PetRepository {
    func fetchPets(fetchCollection path: String) async throws -> [Pet]
    func createPet(collection path: String, data: Pet) async throws -> Bool
}
