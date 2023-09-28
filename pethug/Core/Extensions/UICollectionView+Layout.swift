//
//  UICollectionView+Layout.swift
//  pethug
//
//  Created by Raul Pena on 25/09/23.
//

import UIKit


extension UICollectionLayoutListConfiguration {
    static func createBaseListConfigWithSeparators() -> UICollectionLayoutListConfiguration {
//        Configura el tipo de agrupamiento de las celdas en cada section y tambien las lineas de separacion
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        if #available(iOS 14.5, *) {
            listConfiguration.itemSeparatorHandler = { indexPath, sectionSeparatorConfiguration in
                var configuration = sectionSeparatorConfiguration
                configuration.topSeparatorVisibility = indexPath.row == 0 ? .hidden : .visible
                configuration.topSeparatorInsets.leading = 0
                configuration.bottomSeparatorInsets.leading = 0
                configuration.topSeparatorInsets.trailing = 0
                configuration.bottomSeparatorInsets.trailing = 0
                configuration.color = .separator.withAlphaComponent(0.5)
                return configuration
            }
        } else {
            // Fallback on earlier versions
        }
        listConfiguration.backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        return listConfiguration
    }
    
    static func createBaseListConfigWithSeparatorsWithInsets(leftInset: CGFloat, rightInset: CGFloat) -> UICollectionLayoutListConfiguration {
//        Configura el tipo de agrupamiento de las celdas en cada section y tambien las lineas de separacion
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        if #available(iOS 14.5, *) {
            listConfiguration.itemSeparatorHandler = { indexPath, sectionSeparatorConfiguration in
                var configuration = sectionSeparatorConfiguration
                configuration.topSeparatorVisibility = indexPath.row == 0 ? .hidden : .visible
                configuration.topSeparatorInsets.leading = leftInset
                configuration.bottomSeparatorInsets.leading = leftInset
                configuration.topSeparatorInsets.trailing = rightInset
                configuration.bottomSeparatorInsets.trailing = rightInset
                configuration.color = .separator.withAlphaComponent(0.5)
                return configuration
            }
        } else {
            // Fallback on earlier versions
        }
        listConfiguration.backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        return listConfiguration
    }
}

extension NSCollectionLayoutSection {
    static func createPetsLayout() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50) // Adjust the height as needed
        )
        
        let spacingheader = CGFloat(-24)

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top,
            absoluteOffset: .init(x: 0, y: spacingheader)
        )
        

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(190)
        )
        
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: groupSize,
//                    repeatingSubitem: item,
//                    count: 2
//                )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let spacing = CGFloat(40)
        group.interItemSpacing = .fixed(spacing)
//                group.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
}

extension NSCollectionLayoutSection {
    static func createNewPetGalleryLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(60)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
//                group.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}
