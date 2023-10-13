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
    ///Using data(as Pet.self) cant be because it wont recongize nil values
    ///change it tomorrow
    let id: String
    let name: String
    let gender: Gender?
    let breed: String
    let imagesUrls: [String]
    let type: PetType
    let size: Size?
    let age: Int
    let activityLevel: Int
    let socialLevel: Int
    let affectionLevel: Int
    let address: State
    let info: String
    var isLiked: Bool
    let timestamp: Timestamp
    
    init(
        id: String,
        name: String,
        gender: Gender?,
        size: Size? = nil,
        breed: String,
        imagesUrls: [String],
        type: PetType,
        age: Int,
        activityLevel: Int,
        socialLevel: Int,
        affectionLevel: Int,
        address: State,
        info: String,
        isLiked: Bool,
        timestamp: Timestamp
    ) {
        self.id = id
        self.name = name
        self.gender = gender
        self.size = size
        self.breed = breed
        self.imagesUrls = imagesUrls
        self.type = type
        self.age = age
        self.activityLevel = activityLevel
        self.socialLevel = socialLevel
        self.affectionLevel = affectionLevel
        self.address = address
        self.info = info
        self.isLiked = isLiked
        self.timestamp = timestamp
    }
    
    //Cant decode Timestamp and null values at the same time so this is the solution
    init(dictionary: [String: Any]) {
        self.id             = dictionary["id"]             as? String ?? ""
        self.name           = dictionary["name"]           as? String ?? ""
        self.gender         = Gender.fromString(dictionary["gender"] as? String)
        self.size           = Size.fromString(dictionary["size"] as? String)
        self.breed          = dictionary["breed"]          as? String ?? ""
        self.imagesUrls     = dictionary["imagesUrls"]     as? [String] ?? []
        self.type           = PetType.fromString(dictionary["type"] as! String)
        self.age            = dictionary["age"]            as? Int ?? 0
        self.activityLevel  = dictionary["activityLevel"]  as? Int ?? 0
        self.socialLevel    = dictionary["socialLevel"]    as? Int ?? 0
        self.affectionLevel = dictionary["affectionLevel"] as? Int ?? 0
        self.address        = State.fromString(dictionary["address"] as! String)
        self.info           = dictionary["info"]           as? String ?? ""
        self.isLiked        = dictionary["isLiked"]        as? Bool ?? false
        self.timestamp      = dictionary["timestamp"]      as? Timestamp ?? Timestamp(date: Date())
    }
    //Became useless, delete it at the end of project
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            self.id             = try container.decode(String.self,    forKey: .id)
            self.name           = try container.decode(String.self,    forKey: .name)
            self.breed          = try container.decode(String.self,    forKey: .breed)
            self.imagesUrls     = try container.decode([String].self,  forKey: .imagesUrls)
            self.age            = try container.decode(Int.self,       forKey: .age)
            self.activityLevel  = try container.decode(Int.self,       forKey: .activityLevel)
            self.socialLevel    = try container.decode(Int.self,       forKey: .socialLevel)
            self.affectionLevel = try container.decode(Int.self,       forKey: .affectionLevel)
            self.info           = try container.decode(String.self,    forKey: .info)
            self.isLiked        = try container.decode(Bool.self,      forKey: .isLiked)
            self.timestamp      = try container.decode(Timestamp.self, forKey: .timestamp)
        
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
        
        
        var getPath: String {
            switch self {
            case .dog:
                return .getPath(for: .dogs)
            case .cat:
                return .getPath(for: .cats)
            case .bird:
                return .getPath(for: .birds)
            case .rabbit:
                return .getPath(for: .rabbits)
            }
        }
        
        var storagePath: String {
            switch self {
            case .dog:
                return .getStoragePath(for: .dogs)
            case .cat:
                return .getStoragePath(for: .cats)
            case .bird:
                return .getStoragePath(for: .birds)
            case .rabbit:
                return .getStoragePath(for: .rabbits)
            }
        }
        
        static func fromString(_ typeString: String) -> PetType {
            return PetType(rawValue: typeString.lowercased()) ?? .rabbit
        }
    }
    
    enum Gender: String, Codable, Hashable {
        case male
        case female
        
        static func fromString(_ typeString: String?) -> Gender? {
            guard let typeString = typeString else { return nil }
            return Gender(rawValue: typeString.lowercased()) ?? .female
        }
    }
    
    enum Size: String, Codable, Hashable {
        case small
        case medium
        case large
        
        static func fromString(_ typeString: String?) -> Size? {
            guard let typeString = typeString else { return nil }
            return Size(rawValue: typeString.lowercased()) ?? .small
        }
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
        
        static func fromString(_ typeString: String) -> State {
            return State(rawValue: typeString) ?? .Queretaro
        }
    }
    
}

extension Pet {
    enum FilterType: String, Codable, Hashable {
        case all
        case dog
        case cat
        case bird
        case rabbit
    }
    
    enum FilterGender: String, Codable, Hashable {
        case all
        case male
        case female
    }
    
    enum FilterSize: String, Codable, Hashable {
        case all
        case small
        case medium
        case large
    }
    
    enum FilterState: String, Codable, Hashable, CaseIterable {
        case AllCountry
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


