//
//  PetGalleryCollectionViewCell+Types.swift
//  pethug
//
//  Created by Raul Pena on 08/10/23.
//

import UIKit

//MARK: - Types
extension PetViewGalleryCollectionViewCell {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case image
    }
    
    enum Item: Hashable {
        case image(String)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

