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
        case image(GalleryImage)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

struct GalleryImage: Hashable {
    let id = UUID().uuidString
    let isEmpty: Bool
    let image: UIImage?
    
    init(isEmpty: Bool = false, image: UIImage? = nil) {
        self.isEmpty = isEmpty
        self.image = image
    }
}


