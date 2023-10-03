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
    let gender: Gender
    let size: Size
    let breed: String
    let imageUrl: String
    let type: PetType
    let address: State
    var isLiked: Bool
    
    init(
        id: String,
        name: String,
        age: Int,
        gender: Gender,
        size: Size,
        breed: String,
        imageUrl: String,
        type: PetType,
        address: State,
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
    enum PetType: String, Codable, Hashable {
        case dog
        case cat
        case bird
        case rabbit
    }
    
    enum Gender: String, Codable, Hashable {
        case male
        case female
    }
    
    enum Size: String, Codable, Hashable {
        case small
        case medium
        case large
    }
    
    enum State: String, Codable, Hashable, CaseIterable {
        case Aguascalientes
        case BajaCalifornia = "Baja California"
        case BajaCaliforniaSur = "Baja California Sur"
        case Campeche
        case Chiapas
        case Chihuahua
        case Coahuila
        case Colima
        case Durango
        case Guanajuato
        case Guerrero
        case Hidalgo
        case Jalisco
        case MexicoCity = "Ciudad de Mexico"
        case MexicoState = "Estado de Mexico"
        case Michoacan
        case Morelos
        case Nayarit
        case NuevoLeon = "Nuevo Leon"
        case Oaxaca
        case Puebla
        case Queretaro
        case QuintanaRoo = "Quintana Roo"
        case SanLuisPotosi = "San Luis Potosi"
        case Sinaloa
        case Sonora 
        case Tabasco 
        case Tamaulipas 
        case Tlaxcala 
        case Veracruz 
        case Yucatan 
        case Zacatecas 
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

enum BirdBreed: String, Codable {
    case colibri
    case tucan
}

enum RabbitBreed: String, Codable {
    case americanFuzzyLop
    case hollandLop
}
