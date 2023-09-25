//
//  PetCellViewModel.swift
//  pethug
//
//  Created by Raul Pena on 24/09/23.
//

import Foundation

final class PetCellViewModel {
    //MARK: - Private properties
    
    //MARK: - Internal properties
    var pet: Pet
    var petImage: String {
        pet.age < 1 ? "sal" : "pr\(pet.age)"
    }
    var heartImage: String {
        pet.isLiked ?  "heart.fill" : "heart"
    }
    var name: String {
        pet.name
    }
    var address: String {
        pet.address
    }
    var id: String {
        pet.id
    }
    
    
    //MARK: - LifeCycle
    init(pet: Pet) {
        self.pet = pet
    }
}
