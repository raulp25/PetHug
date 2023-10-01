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
        case info
        case address
        case end
    }
    
    enum Item: Hashable {
        case name
        case gallery
        case type
        case breed
        case gender
        case size
        case info
        case address
        case end
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}


///For the editing feature
//extension NewPetContentViewController {
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
//
//    enum Section: Int {
//        case name
//        case gallery
//        case type
//        case gender
//        case size
//        case info
//        case end
//    }
//
//    enum Item: Hashable {
//        case name(String)
//        case gallery([Data ir UIImage])
//        case type(pet.type)
//        case gender(pet.gender)
//        case size(pet.size)
//        case info(String)
//        case end
//    }
//
//    struct SnapData {
//        var key: Section
//        var values: [Item]
//    }
//}


