//
//  PopupSearch.swift
//  pethug
//
//  Created by Raul Pena on 29/09/23.
//


import UIKit

protocol BreedPopupSearchDelegate: AnyObject {
    func didSelectBreed(breed: String)
    func didTapCancell()
}

class BreedPopupSearch: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    //MARK: - Private  components
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton.createTextButton(with: "cerrar", fontSize: 18, color: UIColor.orange)
        btn.addTarget(self, action: #selector(didTapCancell), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Private properties
    private var inSearchMode: Bool {
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var currentSnapData = [SnapData]()
    
    //MARK: - Internal Properties
    var delegate: BreedPopupSearchDelegate?
    var breedsForType: Pet.PetType?
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSearchController()
        configureUI()
        configureDataSource()
        updateSnapShot()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.isActive = true
    }
    
    
    deinit {
        print("✅ Deinit BreedPopupSearch")
    }
    
    //MARK: - Private actions
    @objc func didTapCancell() {
        delegate?.didTapCancell()
    }
    
    //MARK: - Setup
    func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Buscar por raza"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.returnKeyType = .default
    }
    
    func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(collectionView)

        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: cancelButton.topAnchor,
            right: view.rightAnchor,
            paddingTop: 0,
            paddingLeft: 23,
            paddingRight: 23
        )
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.borderColor = customRGBColor(red: 220, green: 220, blue: 220).cgColor
        collectionView.layer.borderWidth = 1
        
        cancelButton.anchor(
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            paddingLeft: 23,
            paddingBottom: 5,
            paddingRight: 23
        )
    }
    

    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            searchController.searchBar.becomeFirstResponder()
        })
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            
            guard let self else { fatalError() }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparators(separatorColor: customRGBColor(red: 225, green: 225, blue: 225))
            
            switch section {
            case .breed:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
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
        
        
        let titleViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<SearchBreedListCellConfiguration>, SearchBreed> { [weak self] cell, _, model in
            guard let self = self else { return }
            cell.viewModel = model
            cell.viewModel?.delegate = self
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .breed(breed):
                return collectionView.dequeueConfiguredReusableCell(using: titleViewCellRegistration, for: indexPath, item: breed)
            }
            
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath -> UICollectionReusableView? in
            guard let self else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .breed:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
        
    }
    func generatePetBreeds() -> [Item] {
        var breeds = [Item]()
        
        var petTypeArr = [String]()
        
        switch breedsForType {
        case .dog:
            petTypeArr = dog_breeds
        case .cat:
            petTypeArr = cat_breeds
        case .bird:
            petTypeArr = bird_breeds
        case .rabbit:
            petTypeArr = rabbit_breeds
        case .none:
            print("")
        }

        for breed in petTypeArr {
            breeds.append(.breed(.init(breed: breed)))
        }
        
        return breeds
    }
    
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
        currentSnapData  = [
            .init(key: .breed, values: generatePetBreeds())
        ]
        
        snapshot = Snapshot()
        snapshot.appendSections(currentSnapData.map {
            return $0.key
        })
        
        for datum in currentSnapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }

        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
}

//MARK: -  UISearchController updateSearchResults
extension BreedPopupSearch {
    func updateSearchResults(for searchController: UISearchController) {
        if let breedSectionIndex = currentSnapData.firstIndex(where: { $0.key == .breed }) {
            guard let searchText = searchController.searchBar.text else { return }
            
            var items: [Item] = []
            var snapshot = Snapshot()
            
            if searchText.isEmpty {
                items = currentSnapData[breedSectionIndex].values
            }
            
            if !searchText.isEmpty {
                items = currentSnapData[breedSectionIndex].values.filter { item in
                    switch item {
                    case .breed(let breed):
                        return breed.breed.lowercased().contains(searchText.lowercased())
                    }
                }
            }
            
            
            snapshot.appendSections([.breed])
            snapshot.appendItems(items, toSection: .breed)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
    
extension BreedPopupSearch: SearchBreedDelegate {
    func didTapCell(breed: String) {
        delegate?.didSelectBreed(breed: breed)
    }

}
        

