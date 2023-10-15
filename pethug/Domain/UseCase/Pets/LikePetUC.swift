//
//  LikePetUC.swift
//  pethug
//
//  Created by Raul Pena on 14/10/23.
//

import Foundation
//MARK: - Protocol
protocol LikePetUC {
    func execute(data: Pet) async throws
}


//MARK: - Implementation
final class DefaultLikePetUC: LikePetUC {
    private let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
    
    func execute(data: Pet) async throws {
        let pets = try await petRepository.likePet(data: data)
        
        return pets
    }
}


protocol ComposeLikePetUC {
    static func composeLikePetUC() -> DefaultLikePetUC
}

struct LikePet: ComposeLikePetUC {
    static func composeLikePetUC() -> DefaultLikePetUC {
        DefaultLikePetUC(petRepository: DefaultPetRepository(petDataSource: DefaultPetDataSource()))
    }
}


