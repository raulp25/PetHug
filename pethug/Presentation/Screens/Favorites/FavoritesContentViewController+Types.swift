//
//  FavoritesContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

//MARK: - Types
extension FavoritesContentViewController {
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


