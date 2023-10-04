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
    let order = "timestamp"
    private let db = Firestore.firestore()
    
    func fetchPets(fetchCollection path: String) async throws -> [Pet] {
        let snapshot = try await db.collection(path)
                                    .order(by: order, descending: true)
                                    .getDocuments()
        
        let docs = snapshot.documents
        
        var pets = [Pet]()
        for doc in docs {
            let mappedPet = try doc.data(as: Pet.self)
            pets.append(mappedPet)
        }
        
        return pets
    }
    
    func createPet(collection path: String, data: Pet) async throws -> Bool {
        let petFirebaseEntinty = data.toFirebaseEntity()
        let dataModel = petFirebaseEntinty.toObjectLiteral()
        
        let db = Firestore.firestore()
        try await db.collection(path).document(data.id).setData(dataModel)
        return true
        
    }
}
