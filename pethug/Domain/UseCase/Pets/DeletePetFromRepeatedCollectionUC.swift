//
//  DeletePetFromRepeatedCollectionUC.swift
//  pethug
//
//  Created by Raul Pena on 05/10/23.
//

import Foundation
//MARK: - Protocol
protocol DeletePetFromRepeatedCollectionUC {
    func execute(collection path: String, docId: String) async throws -> Bool
}


//MARK: - Implementation
final class DefaultDeletePetFromRepeatedCollectionUC: DeletePetFromRepeatedCollectionUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(collection path: String, docId: String) async throws -> Bool {
        let result = try await petRepository.deletePetFromRepeated(collection: path, docId: docId)
        
        return result
    }
}


protocol ComposeDeletePetFromRepeatedCollectionUC {
    static func composeDeletePetFromRepeatedCollectionUC() -> DefaultDeletePetFromRepeatedCollectionUC
}

struct DeletePetFromRepeatedCollection: ComposeDeletePetFromRepeatedCollectionUC {
    static func composeDeletePetFromRepeatedCollectionUC() -> DefaultDeletePetFromRepeatedCollectionUC {
        DefaultDeletePetFromRepeatedCollectionUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


