//
//  PetsDataSource.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
import FirebaseFirestore

//MARK: - Protocol
protocol PetDataSource {
    func fetchPets(fetchCollection path: String) async throws -> [Pet]
    func fetchUserPets() async throws -> [Pet]
    func createPet(collection path: String, data: Pet) async throws -> Bool
    func updatePet(collection path: String, data: Pet) async throws -> Bool
    func deletePet(collection path: String, docId: String) async throws -> Bool
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool
}

//Todo add fetchPets(for userId)
final class DefaultPetDataSource: PetDataSource {
    let order = "timestamp"
    private let db = Firestore.firestore()
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet] {
        let snapshot = try await db.collection(path)
                                    .order(by: order, descending: true)
                                    .getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        for doc in docs {
            let dictionary = doc.data()
            let pet = Pet(dictionary: dictionary)
            pets.append(pet)
            
        }
        
        return pets
    }
    
    
    func fetchUserPets() async throws -> [Pet] {
        let uid = AuthService().uid
        let snapshot = try await db.collection("users")
                                    .document(uid)
                                    .collection("pets")
                                    .order(by: order, descending: true)
                                    .getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        for doc in docs {
            let dictionary = doc.data()
            let pet = Pet(dictionary: dictionary)
            pets.append(pet)
            
        }
        
        return pets
    }
    
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toObjectLiteral()
        try await db.collection(path)
                    .document(data.id)
                    .setData(dataModel)
        
        try await db.collection("users")
                    .document(uid)
                    .collection("pets")
                    .document(data.id)
                    .setData(dataModel)
        return true
        
    }
    
    func updatePet(collection path: String, data: Pet) async throws -> Bool {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toObjectLiteral()
        
        try await db.collection(path)
                    .document(data.id)
                    .setData(dataModel)
        
        try await db.collection("users")
                    .document(uid)
                    .collection("pets")
                    .document(data.id)
                    .setData(dataModel)
        return true
        
    }
    
    func deletePet(collection path: String, docId: String) async throws -> Bool {
        let uid = AuthService().uid
        try await db.collection("users")
                    .document(uid)
                    .collection("pets")
                    .document(docId).delete()
        return true
    }
    
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool {
        let uid = AuthService().uid
        
        try await db.collection(path)
                    .document(docId)
                    .delete()
        return true
    }
}
