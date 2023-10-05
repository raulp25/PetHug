//
//  DeletePetUC.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import Foundation
//MARK: - Protocol
protocol DeletePetUC {
    func execute(collection path: String, docId: String) async throws -> Bool
}


//MARK: - Implementation
final class DefaultDeletePetUC: DeletePetUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(collection path: String, docId: String) async throws -> Bool {
        let result = try await petRepository.deletePet(collection: path, docId: docId)
        
        return result
    }
}


protocol ComposeDeletePetUC {
    static func composeDeletePetUC() -> DefaultDeletePetUC
}

struct DeletePet: ComposeDeletePetUC {
    static func composeDeletePetUC() -> DefaultDeletePetUC {
        DefaultDeletePetUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}

