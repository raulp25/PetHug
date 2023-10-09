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

struct MedicalInfo: Hashable {
    var internalDeworming: Bool
    var externalDeworming: Bool
    var microchip: Bool
    var sterilized: Bool
    var vaccinated: Bool
}

struct SocialInfo: Hashable {
    var maleDogFriendly: Bool
    var femaleDogFriendly: Bool
    var maleCatFriendly: Bool
    var femaleCatFriendly: Bool
}

