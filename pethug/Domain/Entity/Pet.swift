//
//  Dog.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

class Pet: Codable, Hashable {
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    
    let id: String
    let name: String
    let age: Int
    let gender: String
    let size: String
    let breed: String
    let imageUrl: String
    let type: PetType
    let address: String
    var isLiked: Bool
    
    init(
        id: String,
        name: String,
        age: Int,
        gender: String,
        size: String,
        breed: String,
        imageUrl: String,
        type: PetType,
        address: String,
        isLiked: Bool
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.size = size
        self.breed = breed
        self.imageUrl = imageUrl
        self.type = type
        self.address = address
        self.isLiked = isLiked
    }
}

extension Pet {
    enum PetType: Codable, Hashable {
        case dog(DogBreed)
        case cat(CatBreed)
        case bird
        case rabbit
    }
}


enum DogBreed: String, Codable {
    case goldenRetriever
    case labradorRetriever
    // Add more dog breeds here
}

enum CatBreed: String, Codable {
    case persian
    case siamese
    // Add more cat breeds here
}
