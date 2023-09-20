//
//  Dog.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

struct Pet: Codable, Hashable {
    let id: String
    let name: String
    let age: Int
    let gender: String
    let size: String
    let breed: String
    let imageUrl: String
    let type: PetType
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
