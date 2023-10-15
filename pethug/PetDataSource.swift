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
    var db: Firestore { get set }
    var query: Query! { get set }
    var documents: [QueryDocumentSnapshot] { get set }
    var order: String { get set }
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet]
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet]
    func fetchPetsWithFilter(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet]
    func createPet(collection path: String, data: Pet) async throws -> Bool
    func updatePet(collection path: String, data: Pet) async throws -> Bool
    func deletePet(collection path: String, docId: String) async throws -> Bool
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool
    
    func likePet(data: Pet) async throws
}

final class DefaultPetDataSource: PetDataSource {
    internal var db = Firestore.firestore()
    internal var query: Query!
    internal var documents = [QueryDocumentSnapshot]()
    internal var order = "timestamp"
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet] {
        if query == nil {
            query = db.collection(path)
                      .order(by: order, descending: true)
                      .limit(to: 10)
        } else {
            if !documents.isEmpty {
                query = query.start(afterDocument: documents.last!)
            }
        }
        
        
        let snapshot = try await query.getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        
        for doc in docs {
            let dictionary = doc.data()
            let pet = Pet(dictionary: dictionary)
            pets.append(pet)
            documents += [doc]
        }
        
        
        return pets
    }
    
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let uid = AuthService().uid
        
        if resetPagination {
            query = nil
        }
        
        if query == nil {
            query = db.collection("users")
                      .document(uid)
                      .collection("pets")
                      .order(by: order, descending: true)
                      .limit(to: 10)
        } else {
            if !documents.isEmpty {
                query = query.start(afterDocument: documents.last!)
            }
        }
        
        
        let snapshot = try await query.getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        
        for doc in docs {
            let dictionary = doc.data()
            let pet = Pet(dictionary: dictionary)
            pets.append(pet)
            documents += [doc]
            
        }
        
        return pets
    }
    
    func fetchPetsWithFilter(options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        if resetFilterQueries {
            query = nil
            documents = []
        }
        
        if query == nil {
           query = buildQuery(for: options)
        }
        
        if !documents.isEmpty {
            query = query.start(afterDocument: documents.last!)
        }
        
        let snapshot = try await query.getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        
        for doc in docs {
            let dictionary = doc.data()
            let pet = Pet(dictionary: dictionary)
            pets.append(pet)
            documents += [doc]
            
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
        try await db.collection(path)
                    .document(docId)
                    .delete()
        return true
    }
    
    func likePet(data: Pet) async throws {
        
        try await updateOwnersPetLikes(data: data)
        
        try await addPetToUserLikedPets(data: data)
    }
    
    func updateOwnersPetLikes(data: Pet) async throws {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toObjectLiteral()
        print("datamodel-1 en updateOwnersPetLikes 919: => \(dataModel)")
        try await db.collection(data.type.getPath)
                    .document(data.id)
                    .setData(dataModel)
        
        try await db.collection("users")
            .document(data.owneruid)
                    .collection("pets")
                    .document(data.id)
                    .setData(dataModel)

    }
    
    func addPetToUserLikedPets(data: Pet) async throws {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toObjectLiteral()
        print("datamodel-2 en updateOwnersPetLikes 919: => \(dataModel)")
        try await db.collection("users")
                    .document(uid)
                    .collection("likedPets")
                    .document(data.id)
                    .setData(dataModel)
    }
}



