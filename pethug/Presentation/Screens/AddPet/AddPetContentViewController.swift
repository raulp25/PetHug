//
//  AddPetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit
protocol AddPetContentViewControllerDelegate: AnyObject {
//    func didTap(recipient: Pet)
//    func didTap(_:  Any)
}

final class AddPetContentViewController: UIViewController {
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
                name: k < 2 ? "Ruti" : k < 5 ? "Gregoria" : "Doli",
                age: k,
                gender: .male,
                size: .medium,
                breed: "Girl",
                imagesUrls: [],
                type: .cat,
                address: .BajaCaliforniaSur,
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
                supplementaryView.titleLabel.text = "Sube, edita o borra tus animales en adopcion"
                supplementaryView.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }

        
        let petViewCellRegistration = UICollectionView.CellRegistration<AddPetControllerCollectionViewCell, Pet> { cell, _, model in
            cell.configure(with: model)
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
        currentSnapData  = [.init(key: .pets, values: generatePet(total: 5))]
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



        




