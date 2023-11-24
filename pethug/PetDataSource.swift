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
    
    func fetchAllPets(resetFilterQueries: Bool) async throws -> [Pet]
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] 
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
        async let dogsSnapshot    = try applyFetchAllPets(collection: .getPath(for: .dogs),
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &dogsQuery,
                                                          documents: &dogsdocuments)
        
        async let catsSnapshot    = try applyFetchAllPets(collection: .getPath(for: .cats),
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &catsQuery,
                                                          documents: &catsdocuments)
        
        async let birdsSnapshot   = try applyFetchAllPets(collection: .getPath(for: .birds),
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &birdsQuery,
                                                          documents: &birdsdocuments)
        
        async let rabbitsSnapshot = try applyFetchAllPets(collection: .getPath(for: .rabbits),
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &rabbitsQuery,
                                                          documents: &rabbitsdocuments)
        
        let results = try await [dogsSnapshot, catsSnapshot, birdsSnapshot, rabbitsSnapshot]

        let pets: [Pet] = results[0] + results[1] + results[2] + results[3]
        
        return pets.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() } //Sort by most recent
    }
    
    func applyFetchAllPets(
        collection path: String,
        resetFilterQueries: Bool,
        query: inout Query?,
        documents: inout [QueryDocumentSnapshot]
    ) async throws -> [Pet] {
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
                query = query!.start(afterDocument: documents.last!)
            }
        }      
        
        
        let snapshot = try await query!.getDocuments()
        
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
    
    //filter all collections at once
    func fetchAllPets(withFilter options: FilterOptions, resetFilterQueries: Bool) async throws -> [Pet] {
        async let dogsSnapshot    = try applyFetchAllPets(collection: .getPath(for: .dogs),
                                                          withFilter: options,
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &dogsQuery,
                                                          documents: &dogsdocuments)
        
        async let catsSnapshot    = try applyFetchAllPets(collection: .getPath(for: .cats),
                                                          withFilter: options,
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &catsQuery,
                                                          documents: &catsdocuments)
        
        async let birdsSnapshot   = try applyFetchAllPets(collection: .getPath(for: .birds),
                                                          withFilter: options,
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &birdsQuery,
                                                          documents: &birdsdocuments)
        
        async let rabbitsSnapshot = try applyFetchAllPets(collection: .getPath(for: .rabbits),
                                                          withFilter: options,
                                                          resetFilterQueries: resetFilterQueries,
                                                          query: &rabbitsQuery,
                                                          documents: &rabbitsdocuments)
        
        let results = try await [dogsSnapshot, catsSnapshot, birdsSnapshot, rabbitsSnapshot]

        let pets: [Pet] = results[0] + results[1] + results[2] + results[3]
        
        return pets.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() } //Sort by most recent
    }
    
    func applyFetchAllPets(
        collection path: String,
        withFilter options: FilterOptions,
        resetFilterQueries: Bool,
        query: inout Query?,
        documents: inout [QueryDocumentSnapshot]
    ) async throws -> [Pet] {
        if resetFilterQueries {
            query = nil
            documents = []
        }
        
        if query == nil {
           query = buildQuery(for: options, collection: path)
        }
        
        if !documents.isEmpty {
            query = query!.start(afterDocument: documents.last!)
        }
        
        let snapshot = try await query!.getDocuments()
        
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
    
    
    //filter only a one collection
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
        
        func sortPets() -> [Pet] {
            return pets.sorted { (pet1, pet2) in
                let likeTimestamp1 = pet1.likesTimestamps.first { $0.uid == uid }
                let likeTimestamp2 = pet2.likesTimestamps.first { $0.uid == uid }
                return likeTimestamp1?.timestamp.dateValue() ?? Date() > likeTimestamp2?.timestamp.dateValue() ?? Date() //Sort by most recent
            }
        }
        
        return sortPets()
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
    
    private func createPetInSingle(collection path: String, data: Pet) async throws{
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
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toDictionaryLiked()
        
        try await db.collection(data.type.getPath)
            .document(data.id)
            .updateData(dataModel)
    }
    
    //MARK: - Dislike
    func dislikePet(data: Pet) async throws {
        try await updateOwnerPetLikes(data: data)
    }
}



