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
        
        
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 50, right: 0)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false 
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
            let sideInsets = CGFloat(40)
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            var listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparators()
//            listConfiguration.headerMode = .supplementary
            switch section {
            case .name:
                print("dogs section")
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                return section
            case .gallery:
//                return .createPetsLayout()
                var listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparatorsWithInsets(leftInset: sideInsets, rightInset: sideInsets)
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                
                return section
            case .type:
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .gender:
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .size:
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .info:
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .end:
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
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
                supplementaryView.titleLabel.text = "Adopta a un amigo"
        }

        
        let newPetNameViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetNameListCellConfiguration>, NewPetName> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        let newPetGalleryViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGalleryListCellConfiguration>, NewPetGallery> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        let newPetTypeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetTypeListCellConfiguration>, NewPetType> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        let newPetGenderViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGenderListCellConfiguration>, NewPetGender> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        let newPetSizeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetSizeListCellConfiguration>, NewPetSize> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        
        let nameMockVM = NewPetName(name: "Fernanda Sanchez")
        nameMockVM.delegate = self
        
        let galleryMockVM = NewPetGallery(images: [])
        
        let typeMockVM = NewPetType(type: .dog(.goldenRetriever))
        
        let genderMockVM = NewPetGender(gender: "")
        
        let sizeMockVM = NewPetSize()
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case .name:
                return collectionView.dequeueConfiguredReusableCell(using: newPetNameViewCellRegistration, for: indexPath, item: nameMockVM)
            case .gallery:
                return collectionView.dequeueConfiguredReusableCell(using: newPetGalleryViewCellRegistration, for: indexPath, item: galleryMockVM)
            case .type:
                return collectionView.dequeueConfiguredReusableCell(using: newPetTypeViewCellRegistration, for: indexPath, item: typeMockVM)
            case .gender:
                return collectionView.dequeueConfiguredReusableCell(using: newPetGenderViewCellRegistration, for: indexPath, item: genderMockVM)
            case .size:
                return collectionView.dequeueConfiguredReusableCell(using: newPetSizeViewCellRegistration, for: indexPath, item: sizeMockVM)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: newPetNameViewCellRegistration, for: indexPath, item: nameMockVM)
            case .end:
                return collectionView.dequeueConfiguredReusableCell(using: newPetNameViewCellRegistration, for: indexPath, item: nameMockVM)
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
        currentSnapData  = [
            .init(key: .name, values: [.name]),
            .init(key: .gallery, values: [.gallery]),
            .init(key: .type, values: [.type]),
            .init(key: .gender, values: [.gender]),
            .init(key: .size, values: [.size]),
            .init(key: .info, values: [.info]),
            .init(key: .end, values: [.end])
        ]
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
    var counter = 0
}

extension NewPetContentViewController: NewPetNameDelegate {
    func textFieldDidChange(text: String) {
        print("cambio texto a: => \(text)")
    }
}

extension NewPetContentViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(":ejecuta didselect con metodo normal => ")
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        counter += 1
        print(":ejecuta didselect con datasource => \(counter)")
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
        




