//
//  DislikePetUC.swift
//  pethug
//
//  Created by Raul Pena on 14/10/23.
//

import Foundation
//MARK: - Protocol
protocol DisLikePetUC {
    func execute(data: Pet) async throws
}


//MARK: - Implementation
final class DefaultDisLikePetUC: DisLikePetUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(data: Pet) async throws {
        let pets = try await petRepository.dislikePet(data: data)
        
        return pets
    }
}


protocol ComposeDisLikePetUC {
    static func composeDisLikePetUC() -> DefaultDisLikePetUC
}

struct DisLikePet: ComposeDisLikePetUC {
    static func composeDisLikePetUC() -> DefaultDisLikePetUC {
        DefaultDisLikePetUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


