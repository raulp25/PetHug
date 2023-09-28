//
//  PetsContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

//MARK: - Types
extension NewPetGalleryCellContentView {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case gallery
    }
    
    enum Item: Hashable {
        case image(UIImage)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}


