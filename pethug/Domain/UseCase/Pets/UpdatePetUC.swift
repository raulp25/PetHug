//
//  UpdatePetUC.swift
//  pethug
//
//  Created by Raul Pena on 04/10/23.
//

import Foundation
//MARK: - Protocol
protocol UpdatePetUC {
    func execute(collection path: String, data: Pet) async throws -> Bool
}


//MARK: - Implementation
final class DefaultUpdatePetUC: UpdatePetUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(collection path: String, data: Pet) async throws -> Bool {
        let result = try await petRepository.updatePet(collection: path, data: data)
        
        return result
    }
}


protocol ComposeUpdatePetUC {
    static func composeUpdatePetUC() -> DefaultUpdatePetUC
}

struct UpdatePet: ComposeUpdatePetUC {
    static func composeUpdatePetUC() -> DefaultUpdatePetUC {
        DefaultUpdatePetUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}



