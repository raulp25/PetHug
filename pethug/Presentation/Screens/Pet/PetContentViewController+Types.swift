//
//  PetsContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit

//MARK: - Types
extension PetContentViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case gallery
        case nameLocation
        case info
        case description
        case medical
        case social
    }
    
    enum Item: Hashable {
        case images([String])
        case nameLocation(NameLocationData)
        case info(InfoData)
        case description(String)
        case medical(MedicalInfo)
        case social(SocialInfo)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

struct NameLocationData: Hashable {
    var name: String
    var breed: String
    var address: String
}

struct InfoData: Hashable {
    var age: Int
    var gender: Pet.Gender?
    var size: Pet.Size?
    var activityLevel: Int
    var socialLevel: Int
    var affectionLevel: Int
}

struct MedicalInfo: Hashable, Codable, Equatable {
    var internalDeworming: Bool
    var externalDeworming: Bool
    var microchip: Bool
    var sterilized: Bool
    var vaccinated: Bool

    init(internalDeworming: Bool, externalDeworming: Bool, microchip: Bool, sterilized: Bool, vaccinated: Bool) {
        self.internalDeworming = internalDeworming
        self.externalDeworming = externalDeworming
        self.microchip         = microchip
        self.sterilized        = sterilized
        self.vaccinated        = vaccinated
    }
    
    init(fromDictionary dictionary: [String: Any]) {
        self.internalDeworming = dictionary["internalDeworming"] as? Bool ?? false
        self.externalDeworming = dictionary["externalDeworming"] as? Bool ?? false
        self.microchip         = dictionary["microchip"] as? Bool ?? false
        self.sterilized        = dictionary["sterilized"] as? Bool ?? false
        self.vaccinated        = dictionary["vaccinated"] as? Bool ?? false
    }
    
    
    func toObjectLiteral() -> [String: Any] {
        return [
            "internalDeworming": internalDeworming,
            "externalDeworming": externalDeworming,
            "microchip": microchip,
            "sterilized": sterilized,
            "vaccinated": vaccinated
        ]
    }
    
}

struct SocialInfo: Hashable, Codable, Equatable {
    var maleDogFriendly: Bool
    var femaleDogFriendly: Bool
    var maleCatFriendly: Bool
    var femaleCatFriendly: Bool
    
    init(maleDogFriendly: Bool, femaleDogFriendly: Bool, maleCatFriendly: Bool, femaleCatFriendly: Bool) {
        self.maleDogFriendly   = maleDogFriendly
        self.femaleDogFriendly = femaleDogFriendly
        self.maleCatFriendly   = maleCatFriendly
        self.femaleCatFriendly = femaleCatFriendly
    }
    
    init(fromDictionary dictionary: [String: Any]) {
        self.maleDogFriendly   = dictionary["maleDogFriendly"] as? Bool ?? false
        self.femaleDogFriendly = dictionary["femaleDogFriendly"] as? Bool ?? false
        self.maleCatFriendly   = dictionary["maleCatFriendly"] as? Bool ?? false
        self.femaleCatFriendly = dictionary["femaleCatFriendly"] as? Bool ?? false
    }
    
    func toObjectLiteral() -> [String: Any] {
        return [
            "maleDogFriendly": maleDogFriendly,
            "femaleDogFriendly": femaleDogFriendly,
            "maleCatFriendly": maleCatFriendly,
            "femaleCatFriendly": femaleCatFriendly,
        ]
    }
}

