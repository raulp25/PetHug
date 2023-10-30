//
//  DefaultPetDataSourceMock.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import Foundation
import FirebaseFirestore

@testable import pethug

final class DefaultPetDataSourceSuccessMock: PetDataSource {
    internal var db = Firestore.firestore()
    internal var query: Query!
    internal var documents = [QueryDocumentSnapshot]()
    internal var order = "timestamp"
    
    internal var dogsQuery: Query!
    internal var catsQuery: Query!
    internal var birdsQuery: Query!
    internal var rabbitsQuery: Query!
    
    internal var dogsdocuments  = [QueryDocumentSnapshot]()
    internal var catsdocuments  = [QueryDocumentSnapshot]()
    internal var birdsdocuments   = [QueryDocumentSnapshot]()
    internal var rabbitsdocuments = [QueryDocumentSnapshot]()
    
    //MARK: - Get
    func fetchAllPets(resetFilterQueries: Bool) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    func applyFetchAllPets(
        collection path: String,
        resetFilterQueries: Bool,
        query: inout Query?,
        documents: inout [QueryDocumentSnapshot]
    ) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    //Fetch pets in general
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    //Fetch user pets
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    //Fetch with filter options
    
    //filter all collections at once
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    func applyFetchAllPets(
        collection path: String,
        withFilter options: FilterOptions,
        resetFilterQueries: Bool,
        query: inout Query?,
        documents: inout [QueryDocumentSnapshot]
    ) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    
    //filter only a one collection
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    //Fetch Liked pets
    func fetchFavoritePets() async throws -> [Pet] {
        let pets: [Pet] = [petMock]
        
        return pets
    }
    
    //MARK: - Create
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        true
    }
    
    func createPetInSingle(collection path: String, data: Pet) async throws{ }
    
    //MARK: - Update
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool {
        true
    }
    
    func handlePetChangedType(oldCollection: String, data: Pet) async throws { }
    
    //MARK: - Delete
    func deletePet(collection path: String, docId: String) async throws -> Bool {
        true
    }
    
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool {
        true
    }
    
    //MARK: - Like
    func likePet(data: Pet) async throws { }
    
    func updateOwnerPetLikes(data: Pet) async throws { }
    
    //MARK: - Dislike
    func dislikePet(data: Pet) async throws { }
}


final class DefaultPetDataSourceFailureMock: PetDataSource {
    internal var db = Firestore.firestore()
    internal var query: Query!
    internal var documents = [QueryDocumentSnapshot]()
    internal var order = "timestamp"
    
    internal var dogsQuery: Query!
    internal var catsQuery: Query!
    internal var birdsQuery: Query!
    internal var rabbitsQuery: Query!
    
    internal var dogsdocuments  = [QueryDocumentSnapshot]()
    internal var catsdocuments  = [QueryDocumentSnapshot]()
    internal var birdsdocuments   = [QueryDocumentSnapshot]()
    internal var rabbitsdocuments = [QueryDocumentSnapshot]()
    
    //MARK: - Get
    func fetchAllPets(resetFilterQueries: Bool) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    func applyFetchAllPets(
        collection path: String,
        resetFilterQueries: Bool,
        query: inout Query?,
        documents: inout [QueryDocumentSnapshot]
    ) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //Fetch pets in general
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    //Fetch user pets
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //Fetch with filter options
    
    //filter all collections at once
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    func applyFetchAllPets(
        collection path: String,
        withFilter options: FilterOptions,
        resetFilterQueries: Bool,
        query: inout Query?,
        documents: inout [QueryDocumentSnapshot]
    ) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    
    //filter only a one collection
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    //Fetch Liked pets
    func fetchFavoritePets() async throws -> [Pet] {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Create
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    func createPetInSingle(collection path: String, data: Pet) async throws{
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Update
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    func handlePetChangedType(oldCollection: String, data: Pet) async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Delete
    func deletePet(collection path: String, docId: String) async throws -> Bool {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Like
    func likePet(data: Pet) async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    func updateOwnerPetLikes(data: Pet) async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Dislike
    func dislikePet(data: Pet) async throws {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
}




