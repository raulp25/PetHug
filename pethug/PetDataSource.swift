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
}
