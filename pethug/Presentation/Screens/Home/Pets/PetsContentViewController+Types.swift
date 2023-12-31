//
//  PetsContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit

//MARK: - Types
extension PetsContentViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case pets
    }
    
    enum Item: Hashable {
        case pet(Pet)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

