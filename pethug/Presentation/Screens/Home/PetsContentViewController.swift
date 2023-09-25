//
//  PetsContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit
protocol PetsContentViewControllerDelegate: AnyObject {
//    func didTap(recipient: Pet)
//    func didTap(_:  Any)
}

final class PetsContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private let headerView: PetsViewHeaderViewController = PetsViewHeaderViewController()
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    
    //MARK: - Internal properties
    private var currentSnapData = [SnapData]() {
        didSet {
            print("cambio currentsnap data checar")
        }
    }
    var snapData: [SnapData] {
        didSet {
//            updateSnapShot()
        }
    }
    
    init(snapData: [SnapData]) {
        self.snapData = snapData
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit PetsContentViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 50, right: 0)
        
        configureDataSource()
        updateSnapShot()
    }
    
    func generatePet(total: Int) -> [Item] {
        var pets = [Item]()
        
        for number in 0...total {
            let k = Int(arc4random_uniform(6))
            pets.append(.pet(.init(
                id: String(number),
                name: "Joanna",
                age: k,
                gender: "F",
                size: "SM",
                breed: "Girl",
                imageUrl: "d",
                type: .cat(.persian),
                address: "Calle Campanario 23, Queretaro",
                isLiked: k < 3 ? false : true
            )))
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
        
        return layout
    }
    
    
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
            <DummySectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
            supplementaryView, string, indexPath in
                supplementaryView.titleLabel.text = "Adopta a un amigo fiel texto largo de preuba a ver pa joanna"
        }

        
        let petViewCellRegistration = UICollectionView.CellRegistration<PetControllerCollectionViewCell, Pet> { cell, _, model in
            cell.configure(with: model, delegate: self)
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .pet(pet):
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: pet)
            }
            
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath -> UICollectionReusableView? in
            guard let self else {
                return nil
            }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .pets:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
    }
        
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
        currentSnapData  = [.init(key: .pets, values: generatePet(total: 211))]
//        snapData  = [.init(key: .pets, values: generatePet(total: 21))]
        
        snapshot = Snapshot()
        snapshot.appendSections(currentSnapData.map {
            print(": section=> \($0.key)")
            return $0.key
        })
//        snapshot.appendSections(snapData.map {
//            print(": section=> \($0.key)")
//            return $0.key
//        })
        
        print("currentSnapData: => \(currentSnapData)")
//        print("currentSnapData: => \(snapData)")
        
        for datum in currentSnapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }
//        for datum in snapData {
//            snapshot.appendItems(datum.values, toSection: datum.key)
//        }
//        print("snapshot en updateSnapshot(): => \(snapshot)")
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}


extension PetsContentViewController: PetContentDelegate {
    func didTapLike(_ pet: PetsContentViewController.Item) {
        switch pet {
        case .pet(let pet):
            pet.isLiked.toggle()
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([pet])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

        



