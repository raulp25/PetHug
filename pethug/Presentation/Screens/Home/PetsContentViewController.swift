//
//  PetsContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit
protocol MessagesContentViewControllerDelegate: AnyObject {
//    func didTap(recipient: Pet)
//    func didTap(_:  Any)
}

final class PetsContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    
    //MARK: - CollectionView layout
//   We have the sectionProvider prop just in case
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .dogs:
                print("dogs section")
                
            }
            
        }
        
        return layout
    }
        
        
    
}

