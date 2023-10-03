//
//  PopupSearchViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

//MARK: - Types
extension BreedPopupSearch {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case breed
    }
    
    enum Item: Hashable {
        case breed(SearchBreed)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}
