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
    private var currentSnapData = [SnapData]()
    
    private let headerView: PetsViewHeaderViewController = PetsViewHeaderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let label = UILabel()
        label.text = "PASON"
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(headerView.view)
        
        headerView.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10)
        headerView.view.setHeight(70)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: headerView.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
        
        configureDataSource()
        
        currentSnapData  = [.init(key: .pets, values: generatePet(total: 21))]
        
        snapshot = Snapshot()
        snapshot.appendSections(currentSnapData.map {
            print(": section=> \($0.key)")
            return $0.key
        })
        
        print("currentSnapData: => \(currentSnapData)")
        
        for datum in currentSnapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func generatePet(total: Int) -> [Item] {
        var pets = [Item]()
        
        for number in 1...total {
            pets.append(.pet(.init(id: String(number), name: "Joanna", age: 3, gender: "F", size: "SM", breed: "Girl", imageUrl: "d", type: .cat(.persian))))
        }
        
        return pets
    }
    
    //MARK: - CollectionView layout
//   We have the sectionProvider prop just in case
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .pets:
                print("dogs section")

                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(170)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 2
                )
                
                let spacing = CGFloat(40)
                group.interItemSpacing = .fixed(spacing)
                group.contentInsets = .init(top: 0, leading: 30, bottom: 0, trailing: 30)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

                return section
            }
            
        }
        
        return layout
    }
    
    
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        
        let petViewCellRegistration = UICollectionView.CellRegistration<PetControllerCollectionViewCell, Pet> { [weak self] cell, _, model in
//            cell.startAnimation()
        }
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .pet(pet):
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: pet)
            }
            
        })
    }
        
    
}

