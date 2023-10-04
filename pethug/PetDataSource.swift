//
//  PetsDataSource.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: - Protocol
protocol PetDataSource {
    func fetchPets(fetchCollection path: String) async throws -> [Pet]
    func createPet(collection path: String, data: Pet) async throws -> Bool
}

final class DefaultPetDataSource: PetDataSource {
    private let db = Firestore.firestore()
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet] {
        ///Usar mapper para transformar los docs
        let snapshot = try await db.collection(path).getDocuments()
        let docs = snapshot.documents
        
        var pets = [Pet]()
        for doc in docs {
            let mappedPet = try doc.data(as: Pet.self)
            pets.append(mappedPet)
        }
        
        return pets
    }
    
    func createPet(collection path: String, data: Pet) async throws -> Bool {
//        let pet: [String: Any] = [
//            "id": data.id,
//            "name": data.name,
//            "age": data.age,
//            "gender": data.gender,
//            "size": data.size,
//            "breed": data.breed,
//            "imageUrl": data.imageUrl,
//            "type": data.type,
//            "address": data.address,
//            "isLiked": data.isLiked
//        ]
        
        
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toObjectLiteral()
        
        print("pet in createPost 578=> \(petFirebaseEntinty)")
        
        let db = Firestore.firestore()
        try await db.collection(path).document(data.id).setData(dataModel)
        return true
        
    }
}
