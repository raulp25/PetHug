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
}

final class FavoritesContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    
    private let titleLabel: UILabel = {
        let label = UILabel(withAutolayout: true)
        label.text = "Mis animales favoritos"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        label.backgroundColor = customRGBColor(red: 252, green: 252, blue: 252)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var isMounted = false
    
    //MARK: - Internal properties
    var snapData: [SnapData] {
        didSet {
            updateSnapShot(animated: true)
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
        print("✅ Deinit FavoritesContentViewController")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureDataSource()
        updateSnapShot()
    }
    
    //MARK: - Setup
    func setup() {
        navigationController?.navigationBar.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)

        titleLabel.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 30
        )
        titleLabel.setHeight(60)
        
        collectionView.anchor(
            top: titleLabel.bottomAnchor,
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
        collectionView.backgroundColor = customRGBColor(red: 252, green: 252, blue: 252)
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout { //Create layout
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
        // petCell
        let petViewCellRegistration = UICollectionView.CellRegistration<FavoriteControllerCollectionViewCell, Pet> { [weak self] cell, _, model in
            guard let self = self else { return }
            cell.configure(with: model, delegate: self)
        }
        
        // dataSource init
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .pet(pet):
                return collectionView.dequeueConfiguredReusableCell(using: petViewCellRegistration, for: indexPath, item: pet)
            }
            
        })
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
    // Dislike pet
    func didTapDislike(_ item: Item, completion: @escaping (Bool) -> Void) {
        if let delegate = delegate {
            switch item {
            case .pet(let pet):
                delegate.didDislike(pet: pet, completion: { result in // Delegate
                    if result == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        }
        // Update the UI independently if Delegate hadn't success disliking the pet
        // to let the user know his attempted action was received
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
    
}







