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
    
    enum Section: Int, CaseIterable, Hashable {
        case dogs
    }
    
    enum Item: Hashable {
        case dogs(Dog)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}
