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
    
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet]
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet]
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet]
    func fetchFavoritePets() async throws -> [Pet]
    
    func createPet(collection path: String, data: Pet) async throws -> Bool
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool
    func deletePet(collection path: String, docId: String) async throws -> Bool
    func deletePetFromRepeated(collection path: String, docId: String) async throws -> Bool
    
    func likePet(data: Pet) async throws
    func dislikePet(data: Pet) async throws
}

final class DefaultPetDataSource: PetDataSource {
    internal var db = Firestore.firestore()
    internal var query: Query!
    internal var documents = [QueryDocumentSnapshot]()
    internal var order = "timestamp"
    //MARK: - Get
    //Fetch pets in general
    func fetchPets(fetchCollection path: String, resetFilterQueries: Bool) async throws -> [Pet] {
        if resetFilterQueries {
            query = nil
            documents = []
        }
        
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
    //Fetch user pets
    func fetchUserPets(with resetPagination: Bool) async throws -> [Pet] {
        let uid = AuthService().uid
        
        if resetPagination {
            query = nil
            documents = []
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
    //Fetch with filter options
    func fetchPets(collection: String, withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        if resetFilterQueries {
            query = nil
            documents = []
        }
        
        if query == nil {
           query = buildQuery(for: options, collection: collection)
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
    //Fetch Liked pets
    func fetchFavoritePets() async throws -> [Pet] {
        let uid = AuthService().uid
        
        
        let dogsQuery = db.collection(.getPath(for: .dogs))
                           .whereField("likedByUsers", arrayContains: uid)
                           .order(by: order, descending: true)
        
        let catsQuery = db.collection(.getPath(for: .cats))
                           .whereField("likedByUsers", arrayContains: uid)
                           .order(by: order, descending: true)
        
        let birdsQuery = db.collection(.getPath(for: .birds))
                           .whereField("likedByUsers", arrayContains: uid)
                           .order(by: order, descending: true)
        
        let rabbitsQuery = db.collection(.getPath(for: .rabbits))
                             .whereField("likedByUsers", arrayContains: uid)
                             .order(by: order, descending: true)
        
        
        async let dogsSnapshot = try dogsQuery.getDocuments()
        async let catsSnapshot = try catsQuery.getDocuments()
        async let birdsSnapshot = try birdsQuery.getDocuments()
        async let rabbitsSnapshot = try rabbitsQuery.getDocuments()
        
        let results = try await [dogsSnapshot, catsSnapshot, birdsSnapshot, rabbitsSnapshot]
        
        let docsArr: [QueryDocumentSnapshot] = results[0].documents +
                                               results[1].documents +
                                               results[2].documents +
                                               results[3].documents

        var pets = [Pet]()
        
        for doc in docsArr {
            let dictionary = doc.data()
            let pet = Pet(dictionary: dictionary)
            pets.append(pet)
            documents += [doc]

        }
        
        return pets.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
    }
    
    //MARK: - Create
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toDictionaryLiteral()
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
    
    func createPetInSingle(collection path: String, data: Pet) async throws{
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toDictionaryLiteral()
        try await db.collection(path)
                    .document(data.id)
                    .setData(dataModel)
        
    }
    //MARK: - Update
    func updatePet(data: Pet, oldCollection: String) async throws -> Bool {
        let collection = data.type.getPath

        if collection != oldCollection {
            
            try await handlePetChangedType(oldCollection: oldCollection, data: data)
            
        } else {
            
            let uid = AuthService().uid
            let petFirebaseEntinty = data.toFirebaseEntity()
            let dataModel = petFirebaseEntinty.toDictionaryUpdate()
            
            try await withThrowingTaskGroup(of: Void.self) { group in
                
                group.addTask { [weak self] in
                    try await self?.db.collection(collection)
                        .document(data.id)
                        .updateData(dataModel)
                }
                group.addTask { [weak self] in
                    try await self?.db.collection("users")
                        .document(uid)
                        .collection("pets")
                        .document(data.id)
                        .updateData(dataModel)
                }
                
                for try await _ in group {}
            }
        }
        
        return true
        
    }
    
    func handlePetChangedType(oldCollection: String, data: Pet) async throws {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let updatedPet = petFirebaseEntinty.toDictionaryUpdate()
        let collection = data.type.getPath
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask { [weak self] in
                let _ = try await self?.deletePetFromRepeated(collection: oldCollection, docId: data.id)
            }
            group.addTask { [weak self] in
                try await self?.db.collection("users")
                    .document(uid)
                    .collection("pets")
                    .document(data.id)
                    .updateData(updatedPet)
            }
            
            group.addTask { [weak self] in
                try await self?.createPetInSingle(collection: collection, data: data)
            }
            
            for try await _ in group {}
        }
    }
    
    //MARK: - Delete
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
    //MARK: - Like
    func likePet(data: Pet) async throws {
        try await updateOwnerPetLikes(data: data)
    }
    
    func updateOwnerPetLikes(data: Pet) async throws {
        let uid = AuthService().uid
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toDictionaryLiked()
        
        try await db.collection(data.type.getPath)
                    .document(data.id)
                    .updateData(dataModel)
        
//        try await db.collection("users")
//            .document(data.owneruid)
//                    .collection("pets")
//                    .document(data.id)
//                    .updateData(dataModel)

    }
    //We dont need it anymore cause we changed the approach
//    func addPetToUserLikedPets(data: Pet) async throws {
//        let uid = AuthService().uid
//        let petFirebaseEntinty = data.toFirebaseEntity()
//        let dataModel = petFirebaseEntinty.toObjectLiteral()
//
//        try await db.collection("users")
//                    .document(uid)
//                    .collection("likedPets")
//                    .document(data.id)
//                    .setData(dataModel)
//    }
    //MARK: - Dislike
    func dislikePet(data: Pet) async throws {
        
        try await updateOwnerPetLikes(data: data)
        
        try await removePetFromUserLikedPets(data: data)
    }
    
    func removePetFromUserLikedPets(data: Pet) async throws {
        let uid = AuthService().uid
        
        try await db.collection("users")
                    .document(uid)
                    .collection("likedPets")
                    .document(data.id)
                    .delete()
    }
    
}



