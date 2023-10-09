//
//  FilterPetsContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

//MARK: - Types
extension FilterPetsContentViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case type
        case breed
        case gender
        case size
        case age
        case address
        case end
    }
    
    enum Item: Hashable {
        case type(FilterPetsType)
        case breed(FilterPetsBreed)
        case gender(NewPetGender)
        case size(NewPetSize)
        case age(NewPetAge)
        case address(NewPetAddress)
        case end(NewPetUpload)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}
