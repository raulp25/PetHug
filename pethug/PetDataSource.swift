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
}

final class DefaultPetDataSource: PetDataSource {
    internal var db = Firestore.firestore()
    internal var query: Query!
    internal var documents = [QueryDocumentSnapshot]()
    internal var order = "timestamp"
    
    ///Filtros :
    ///type    -> where normal
    ///gender  -> where normal
    ///age     -> greater or equal and less than or equal // si usamos age necesitamos o eliminar el order o cambiarlo por age en lugar de timestamp
    ///con las demas condiciones no importa
    ///size    -> where normal
    ///address -> where normal
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet] {
        if query == nil {
//            query = db.collection(path)
//                      .order(by: order, descending: true)
//                      .limit(to: 10)
//          query = db.collection(path)
//                    .order(by: "age", descending: false)
//                    .whereField("gender", isEqualTo: "male")
//                    .whereField("age", isGreaterThanOrEqualTo: 2)
//                    .whereField("age", isLessThanOrEqualTo: 5)
//                    .limit(to: 10)
            
          query = db.collection(path)
                    .order(by: order, descending: true)
//                    .whereField("gender", isEqualTo: "female")
//                    .whereField("address", isEqualTo: "Querétaro")
//                    .whereField("size", isEqualTo: "medium")
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
        
        if query == nil {
//            query = db.collection("users")
//                      .document(uid)
//                      .collection("pets")
//                      .whereField("address", isEqualTo: "Queretaro")
//                      .limit(to: 10)
            
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
            if let type = options.type,
                   type != .all {
                
                query = db.collection(type.rawValue)
                
            } else {
                query = db.collection("birds")
            }
            
            if let age = options.age,
                   age.min != 0 ||
                   age.max != 25 {
                
                if age.min != 0 {
                    query = query.whereField("age", isGreaterThanOrEqualTo: age.min)
                }
                
                if age.max != 25 {
                    query = query.whereField("age", isLessThanOrEqualTo: age.max)
                }
                
                query = query.order(by: "age", descending: false)
                
            } else {
                query = query.order(by: "timestamp", descending: true)
            }
            
            
            
            if let gender = options.gender,
                   gender != .all {
                print("gender .rawvalue: => \(gender.rawValue)")
                query = query.whereField("gender", isEqualTo: gender.rawValue)
                
            }
            
            if let size = options.size,
                   size != .all {
                
                query = query.whereField("size", isEqualTo: size.rawValue)
                
            }
            
           
            
            if let address = options.address,
                   address != .AllCountry {
                
                   query = query.whereField("address", isEqualTo: address.rawValue)
            }
            
            query = query.limit(to: 10)
            
        } else if !documents.isEmpty {
            
            query = query.start(afterDocument: documents.last!)
            
        }
        
        let snapshot = try await query.getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        
        var docsId = [String]()
        
        for doc in docs {
            let dictionary = doc.data()
            docsId.append(doc.documentID)
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
        let uid = AuthService().uid
        
        try await db.collection(path)
                    .document(docId)
                    .delete()
        return true
    }
}



