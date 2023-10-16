//
//  FavoritesContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit
import Firebase
protocol FavoritesContentViewControllerDelegate: AnyObject {
    func didTap(pet: Pet)
    func didDislike(pet: Pet, completion: @escaping (Bool) -> Void)
    func executeFetch()
//    func didTap(_:  Any)
}

final class FavoritesContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var isMounted = false
    //MARK: - Internal properties
    var snapData: [SnapData] {
        didSet {
            updateSnapShot(animated: false)
        }
    }

    weak var delegate: FavoritesContentViewControllerDelegate?
    
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

        collectionView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        
        collectionView.contentInset = .init(
            top: 20,
            left: 0,
            bottom: 50,
            right: 0
        )
        
        configureDataSource()
        updateSnapShot()
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .pets:
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

        
        let petViewCellRegistration = UICollectionView.CellRegistration<FavoriteControllerCollectionViewCell, Pet> { cell, _, model in
            print("llama cellregistration: =")
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
        snapshot = Snapshot()
        snapshot.appendSections(snapData.map {
            return $0.key
        })
        for datum in snapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }
        

        dataSource.apply(snapshot, animatingDifferences: animated)
        
    }
}


extension FavoritesContentViewController: FavoriteContentDelegate {
    func didTapCell(pet: Pet) {
        delegate?.didTap(pet: pet)
    }
    
    func didTapDislike(_ item: Item, completion: @escaping (Bool) -> Void) {
        if let delegate = delegate {
            switch item {
            case .pet(let pet):
                delegate.didDislike(pet: pet, completion: { [self] result in
                    if result == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        }
        
        if let sectionIndex = snapData.firstIndex(where: { $0.key == .pets }),
           let itemIndex = snapData[sectionIndex].values.firstIndex(where: { $0 == item })
        {
            snapData[sectionIndex].values.remove(at: itemIndex)
            
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([item])
            
            DispatchQueue.main.async { [weak self] in
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    func updatePet(_ pet: FavoritesContentViewController.Item) {
        switch pet {
        case .pet(let pet):
            if let indexToUpdate = dataSource.snapshot().itemIdentifiers.firstIndex(where: { item in
                switch item {
                case .pet(let item):
                    if item.id == pet.id {
                        return true
                    }
                }
                return false
            }) {
                    var snapshot = dataSource.snapshot()
                    
                    // Remove the old item
                    snapshot.deleteItems([snapshot.itemIdentifiers[indexToUpdate]])
                    
                    // Insert the updated item at the original index
                snapshot.insertItems([.pet(pet)], beforeItem: snapshot.itemIdentifiers[indexToUpdate])
                    
                    // Apply the updated snapshot on the main thread
                    DispatchQueue.main.async { [weak self] in
                        self?.dataSource.apply(snapshot, animatingDifferences: true)
                    }
                }
              
        }
        
    }
    
}







