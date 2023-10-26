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
            updateSnapShot(animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        let petViewCellRegistration = UICollectionView.CellRegistration<PetControllerCollectionViewCell, Pet> { cell, _, model in
            cell.configure(with: model, delegate: self)
        }
        
        
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






