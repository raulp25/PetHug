//
//  Dog.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
import Firebase

class Pet: Codable, Hashable {
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        (
            lhs.id         == rhs.id         &&
            lhs.name       == rhs.name       &&
            lhs.age        == rhs.age        &&
            lhs.gender     == rhs.gender     &&
            lhs.size       == rhs.size       &&
            lhs.breed      == rhs.breed      &&
            lhs.imagesUrls == rhs.imagesUrls &&
            lhs.type       == rhs.type       &&
            lhs.address    == rhs.address
        )
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
    let imagesUrls: [String]
    let type: PetType
    let address: State
    var isLiked: Bool
    let timestamp: Timestamp
    
    init(
        id: String,
        name: String,
        age: Int,
        gender: Gender = .female,
        size: Size = .medium,
        breed: String,
        imagesUrls: [String],
        type: PetType = .dog,
        address: State = .MexicoCity,
        isLiked: Bool,
        timestamp: Timestamp
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.size = size
        self.breed = breed
        self.imagesUrls = imagesUrls
        self.type = type
        self.address = address
        self.isLiked = isLiked
        self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            self.id = try container.decode(String.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.age = try container.decode(Int.self, forKey: .age)
            self.breed = try container.decode(String.self, forKey: .breed)
            self.imagesUrls = try container.decode([String].self, forKey: .imagesUrls)
            self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
            self.timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
        
            let typeString = try container.decode(String.self, forKey: .type)
            if let petType = PetType(rawValue: typeString) {
                self.type = petType
            } else {
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type value")
            }
        
            let genderString = try container.decode(String.self, forKey: .gender)
            if let genderType = Gender(rawValue: genderString) {
                self.gender = genderType
            } else {
                throw DecodingError.dataCorruptedError(forKey: .gender, in: container, debugDescription: "Invalid type value")
            }
            
            let sizeString = try container.decode(String.self, forKey: .size)
            if let size = Size(rawValue: sizeString) {
                self.size = size
            } else {
                throw DecodingError.dataCorruptedError(forKey: .size, in: container, debugDescription: "Invalid size value")
            }
            
            let addressString = try container.decode(String.self, forKey: .address)
            if let address = State(rawValue: addressString) {
                self.address = address
            } else {
                throw DecodingError.dataCorruptedError(forKey: .address, in: container, debugDescription: "Invalid address value")
            }
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


