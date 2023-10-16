//
//  PetsContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit
import Firebase
protocol PetsContentViewControllerDelegate: AnyObject {
    func didTap(pet: Pet)
    func didLike(pet: Pet, completion: @escaping (Bool) -> Void)
    func didDislike(pet: Pet, completion: @escaping (Bool) -> Void)
    func executeFetch()
//    func didTap(_:  Any)
}

final class PetsContentViewController: UIViewController {
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

    weak var delegate: PetsContentViewControllerDelegate?
    
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
        collectionView.delegate = self
        
        configureDataSource()
        updateSnapShot()
    }
    
//    func generatePet(total: Int) -> [Item] {
//        var pets = [Item]()
//        var counter = 0
//        for number in 0...total {
//            let k = Int(arc4random_uniform(6))
//            pets.append(.pet(.init(
//                id: "32de\(counter)",
//                name: "Laruent\(counter)",
//                gender: .female,
//                size: .small,
//                breed: "Pomeranian\(counter)",
//                imagesUrls: ["firebase/fakeURL"],
//                type: .bird,
//                age: 5,
//                activityLevel: 8,
//                socialLevel: 8,
//                affectionLevel: 9,
//                address: .Campeche,
//                info: "Lets goy cowboys",
//                isLiked: false,
//                timestamp: Timestamp(date: Date())
//            )))
//            counter += 1
//        }
//
//        return pets
//    }
    
    //MARK: - CollectionView layout
//   We have the sectionProvider prop just in case
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

extension PetsContentViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y: Float = Float(offset.y) + Float(bounds.size.height) - Float(inset.bottom)
        let height: Float = Float(size.height)
        let distance: Float = 10
        
        if y > height + distance {
            print(":pasa el limite y \(y) > height + distance \(height + distance) ")
            delegate?.executeFetch()
        }
    }
}

extension PetsContentViewController: PetContentDelegate {
    func didTapCell(pet: Pet) {
        delegate?.didTap(pet: pet)
    }
    
    func didTapLike(_ pet: Pet, completion: @escaping(Bool) -> Void) {
        if let delegate = delegate {
            delegate.didLike(pet: pet, completion: { result in
                if result == true {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    func didTapDislike(_ pet: Pet, completion: @escaping (Bool) -> Void) {
        if let delegate = delegate {
            delegate.didDislike(pet: pet, completion: { result in
                if result == true {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
        
    }






