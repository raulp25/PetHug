//
//  PetCellViewModel.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import Foundation

final class AddPetCellViewModel {
    //MARK: - Internal properties
    var pet: Pet
    
    var petImage: String {
        pet.age < 1 ? "sal" : "pr\(pet.age)"
    }
    
    var heartImage: String {
            pet.isLiked ?  "heart.fill" : "heart"
    }
    
    var isLiked: Bool {
        get {
            pet.isLiked
        }
        
        set {
            pet.isLiked = newValue
        }
    }
    
    var name: String {
        pet.name
    }
    
    var address: Pet.State {
        pet.address
    }
    
    var id: String {
        pet.id
    }
    
    
    //MARK: - LifeCycle
    init(pet: Pet) {
        self.pet = pet
        self.isLiked = pet.isLiked
    }
}
