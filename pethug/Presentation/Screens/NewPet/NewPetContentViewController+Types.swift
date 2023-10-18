//
//  NewPetContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

//MARK: - Types
extension NewPetContentViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case name
        case gallery
        case type
        case breed
        case gender
        case size
        case age
        case activity
        case social
        case affection
        case medicalInfo
        case socialInfo
        case info
        case address
        case end
    }
    
    enum Item: Hashable {
        case name(NewPetName)
        case gallery(NewPetGallery)
        case type(NewPetType)
        case breed(NewPetBreed)
        case gender(NewPetGender)
        case size(NewPetSize)
        case age(NewPetAge)
        case activity(NewPetActivity)
        case social(NewPetSocial)
        case affection(NewPetAffection)
        case info(NewPetInfo)
        case address(NewPetAddress)
        case medicalInfo(NewPetMedicalInfo)
        case socialInfo(NewPetSocialInfo)
        case end(NewPetUpload)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

