//
//  UICollectionView+Layout.swift
//  pethug
//
//  Created by Raul Pena on 25/09/23.
//

import UIKit


extension UICollectionLayoutListConfiguration {
    static func createBaseListConfigWithSeparators(separatorColor: UIColor? = nil) -> UICollectionLayoutListConfiguration {
//        Configura el tipo de agrupamiento de las celdas en cada section y tambien las lineas de separacion
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        if #available(iOS 14.5, *) {
            listConfiguration.itemSeparatorHandler = { indexPath, sectionSeparatorConfiguration in
                var configuration = sectionSeparatorConfiguration
                configuration.topSeparatorVisibility = indexPath.row == 0 ? .hidden : .visible
                configuration.bottomSeparatorVisibility = indexPath.row == indexPath.count ? .hidden : .visible
                configuration.topSeparatorInsets.leading = 0
                configuration.bottomSeparatorInsets.leading = 0
                configuration.topSeparatorInsets.trailing = 0
                configuration.bottomSeparatorInsets.trailing = 0
                configuration.color = separatorColor != nil ? separatorColor! : .separator.withAlphaComponent(0.5)
                return configuration
            }
        } else {
            // Fallback on earlier versions
        }
        listConfiguration.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        return listConfiguration
    }
    
    static func createBaseEndListConfigWithSeparators() -> UICollectionLayoutListConfiguration {
//        Configura el tipo de agrupamiento de las celdas en cada section y tambien las lineas de separacion
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        if #available(iOS 14.5, *) {
            listConfiguration.itemSeparatorHandler = { indexPath, sectionSeparatorConfiguration in
                var configuration = sectionSeparatorConfiguration
                configuration.bottomSeparatorVisibility = .hidden
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
            widthDimension: .absolute(70),
            heightDimension: .absolute(70)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
//                group.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
}


extension NSCollectionLayoutSection {
    
    static func createPetLayout(for section: PetSections) -> NSCollectionLayoutSection {
        
        // Define item size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        // Create item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Define group size for the first section
        let firstSectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
        let firstSectionGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: firstSectionGroupSize, subitems: [item])

        // Define group size for the second section
        let seeconditemSize        = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let seeconditem            = NSCollectionLayoutItem(layoutSize: seeconditemSize)
        let secondSectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let secondSectionGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: secondSectionGroupSize, subitems: [seeconditem])

        // Define group size for the third section
        let thirdItemSize         = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let thirdItem             = NSCollectionLayoutItem(layoutSize: thirdItemSize)
        let thirdSectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let thirdSectionGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: thirdSectionGroupSize, subitems: [thirdItem])

        // Define group size for the fourth section
        let fourthItemSize         = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let fourthItem             = NSCollectionLayoutItem(layoutSize: fourthItemSize)
        let fourthSectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let fourthSectionGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: fourthSectionGroupSize, subitems: [fourthItem])

        // Define group size for the fifth section
        let fifthItemSize         = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let fifthItem             = NSCollectionLayoutItem(layoutSize: fifthItemSize)
        let fifthSectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let fifthSectionGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: fifthSectionGroupSize, subitems: [fifthItem])
        
        
        // Define group size for the fifth section
        let sixthItemSize         = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let sixthItem             = NSCollectionLayoutItem(layoutSize: sixthItemSize)
        let sixthSectionGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let sixthSectionGroup     = NSCollectionLayoutGroup.horizontal(layoutSize: sixthSectionGroupSize, subitems: [sixthItem])

        // Create sections
        switch section {
        case .gallery:
            let firstSection = NSCollectionLayoutSection(group: firstSectionGroup)
            firstSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            return firstSection
        case .galleryImage:
            let firstSection = NSCollectionLayoutSection(group: firstSectionGroup)
            firstSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            firstSection.orthogonalScrollingBehavior = .paging
            
            return firstSection
        case .nameLocation:
            let secondSection = NSCollectionLayoutSection(group: secondSectionGroup)
            secondSection.contentInsets = NSDirectionalEdgeInsets(top:  20, leading: 30, bottom: 0, trailing: 30)
            
            return secondSection
        case .info:
            let thirdSection = NSCollectionLayoutSection(group: thirdSectionGroup)
            thirdSection.interGroupSpacing = 10
            thirdSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30)
            
            return thirdSection
        case .description:
            let fourthSection = NSCollectionLayoutSection(group: fourthSectionGroup)
            fourthSection.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 30, bottom: 0, trailing: 30)
            
            return fourthSection
        case .medical:
            let fifthSection = NSCollectionLayoutSection(group: fifthSectionGroup)
            fifthSection.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 30, bottom: 0, trailing: 30)
            
            return fifthSection
        case .social:
            let sixthSection = NSCollectionLayoutSection(group: sixthSectionGroup)
            sixthSection.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 30, bottom: 20, trailing: 30)
            
            return sixthSection
        }
        
    }
    
    enum PetSections {
        case gallery
        case galleryImage
        case nameLocation
        case info
        case description
        case medical
        case social
    }
}

