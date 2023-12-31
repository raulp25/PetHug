//
//  AddPetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit
protocol AddPetContentViewControllerDelegate: AnyObject {
    func executeFetch()
    func didTapEdit(pet: Pet)
    func didTapDelete(collection path: String, id: String) async -> Bool
}

final class AddPetContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    
    private let titleLabel: UILabel = {
        let label = UILabel(withAutolayout: true)
        label.text = "Sube, edita o borra tus animales en adopcion"
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
    
    //MARK: - Internal properties
    weak var delegate: AddPetContentViewControllerDelegate?
    var snapData: [SnapData] {
        didSet {
            updateSnapShot()
        }
    }
    // This Flag is set after create/update pet to scroll cv to top
    var debounce = false {
        didSet {
            if debounce == true {
                scrollTopCollectionView()
            }
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
        print("✅ Deinit AddpetContentViewController")
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
        collectionView.delegate = self
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
    private func configureDataSource() { // Cell registration
        // PetViewCell
        let petViewCellRegistration = UICollectionView.CellRegistration<AddPetControllerCollectionViewCell, Pet> { [weak self] cell, _, model in
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
    
    private func scrollTopCollectionView() {
        guard debounce else { return }
        collectionView.alpha = 0
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        // Gives dataSource time to visually apply changes without user seeing the process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.collectionView.alpha = 1
            self?.debounce = false
        })
    }
}


extension AddPetContentViewController: UICollectionViewDelegate {
    //Pagination process
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y: Float = Float(offset.y) + Float(bounds.size.height) - Float(inset.bottom)
        let height: Float = Float(size.height)
        let distance: Float = 10
        
        if y > height + distance { // Check if collection view scroll position exceeds the limit
            if NetworkMonitor.shared.isConnected == true {
                delegate?.executeFetch() // Fetch with pagination
            }
        }
    }
}


extension AddPetContentViewController: AddPetContentDelegate {
    
    func didTapEdit(pet item: Item) {
        switch item{
        case .pet(let pet):
            delegate?.didTapEdit(pet: pet)
        }
    }
    
    
    func didTapDelete(pet item: Item, pet id: String) {
        guard let delegate = delegate else { return }
        switch item {
            
        case .pet(let pet):
            let path = pet.type.getPath
            
            Task {
                let result = await delegate.didTapDelete(collection: path, id: id) // Delegate
                
                if let sectionIndex = snapData.firstIndex(where: { $0.key == .pets }),
                   let itemIndex = snapData[sectionIndex].values.firstIndex(where: { $0 == item }),
                   result == true // If delegate deleted pet succesfully
                {
                    snapData[sectionIndex].values.remove(at: itemIndex)
                    
                    var snapshot = dataSource.snapshot()
                    snapshot.deleteItems([item])
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.dataSource.apply(snapshot, animatingDifferences: true)
                    }
                } else {
                    alert(message: "Hubo un error al elminar, intenta nuevamente", title: "Error")
                }
            }
        }
    }
}
        




