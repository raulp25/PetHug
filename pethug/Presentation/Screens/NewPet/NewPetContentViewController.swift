//
//  NewPetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit


final class NewPetContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    
    //MARK: - Internal properties
    private var currentSnapData = [SnapData]() {
        didSet {
            print("cambio currentsnap data checar")
        }
    }
//    var snapData: [SnapData] {
//        didSet {
////            updateSnapShot()
//        }
//    }
//
    
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
//        var pets = [Item]()
//
//        for number in 0...total {
//            let k = Int(arc4random_uniform(6))
//            pets.append(.pet(.init(
//                id: String(number),
//                name: k < 2 ? "Ruti" : k < 5 ? "Gregoria" : "Doli",
//                age: k,
//                gender: "F",
//                size: "SM",
//                breed: "Girl",
//                imageUrl: "d",
//                type: .cat(.persian),
//                address: k < 2 ? "Mirador del Cimatario Cancun Quintana Roo" : k < 5 ? "Huixquilucan Estado de Mexico" : "Calle Campanario 23, Queretaro",
//                isLiked: k < 3 ? false : true
//            )))
//        }
//
//        return pets
        []
    }
    
    //MARK: - CollectionView layout
//   We have the sectionProvider prop just in case
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .name:
                print("dogs section")
                return .createPetsLayout()
            case .gallery:
                return .createPetsLayout()
            case .type:
                return .createPetsLayout()
            case .gender:
                return .createPetsLayout()
            case .size:
                return .createPetsLayout()
            case .info:
                return .createPetsLayout()
            case .end:
                return .createPetsLayout()
            }
            
        }
        
        return layout
    }
    
    
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
            <DummySectionHeader>(elementKind: UICollectionView.elementKindSectionHeader) {
            supplementaryView, string, indexPath in
                supplementaryView.titleLabel.text = "Adopta a un amigo"
        }

        
        let petViewCellRegistration = UICollectionView.CellRegistration<AddPetControllerCollectionViewCell, Pet> { cell, _, model in
//            cell.configure(with: model, delegate: self)
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case .name:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            case .gallery:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            case .type:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            case .gender:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            case .size:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            case .end:
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: nil)
            }
            
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath -> UICollectionReusableView? in
            guard let self else {
                return nil
            }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .name:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case .gallery:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case .type:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case .gender:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case .size:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case .info:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            case .end:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
    }
        
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
//        currentSnapData  = [.init(key: .pets, values: generatePet(total: 60))]
        currentSnapData  = []
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




        




