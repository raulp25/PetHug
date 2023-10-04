//
//  CreatePetUC.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import Foundation
//MARK: - Protocol
protocol CreatePetUC {
    func execute(collection path: String, data: Pet) async throws -> Bool
}


//MARK: - Implementation
final class DefaultCreatePetUC: CreatePetUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(collection path: String, data: Pet) async throws -> Bool {
        let result = try await petRepository.createPet(collection: path, data: data)
        
        return result
    }
}


protocol ComposeCreatePetUC {
    static func composeCreatePetUC() -> DefaultCreatePetUC
}

struct CreatePet: ComposeCreatePetUC {
    static func composeCreatePetUC() -> DefaultCreatePetUC {
        DefaultCreatePetUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


