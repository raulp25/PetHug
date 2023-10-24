//
//  AddressPopupSearch.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol AddressPopupSearchDelegate: AnyObject {
    func didSelectState(state: Pet.State)
    func didTapCancellSearchAddress()
}

class AddressPopupSearch: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
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
    var delegate: AddressPopupSearchDelegate?
   
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
        print("✅ Deinit AddressPopupSearch")
    }
    
    //MARK: - Private actions
    @objc func didTapCancell() {
        print(": => didTapCancell from popup")
        delegate?.didTapCancellSearchAddress()
    }
    
    //MARK: - Setup
    func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Buscar por estado"
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
            case .state:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                return section
            }
            
        }
        return layout
    }
    
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        let titleViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<SearchAddressListCellConfiguration>, SearchAddress> { cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .state(address):
                return collectionView.dequeueConfiguredReusableCell(using: titleViewCellRegistration, for: indexPath, item: address)
            }
            
        })
    }
    
    
    func generateStates() -> [Item] {
        var searchAddresses = [Item]()

        for state in Pet.State.allCases {
            let searchAddress = SearchAddress(address: state.rawValue)
            searchAddress.state = state
            searchAddresses.append(.state(searchAddress))
        }
        
        return searchAddresses
    }
    
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
        currentSnapData  = [
            .init(key: .state, values: generateStates())
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
extension AddressPopupSearch {
    func updateSearchResults(for searchController: UISearchController) {
        if let stateSectionIndex = currentSnapData.firstIndex(where: { $0.key == .state }) {
            guard let searchText = searchController.searchBar.text else { return }
            
            var items: [Item] = []
            var snapshot = Snapshot()
            
            if searchText.isEmpty {
                items = currentSnapData[stateSectionIndex].values
            }
            
            if !searchText.isEmpty {
                items = currentSnapData[stateSectionIndex].values.filter { item in
                    switch item {
                    case .state(let state):
                        return state.address!.lowercased().contains(searchText.lowercased())
                    }
                }
            }
            
            
            snapshot.appendSections([.state])
            snapshot.appendItems(items, toSection: .state)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
}


extension AddressPopupSearch: SearchAddressDelegate {
    func didTapCell(state: Pet.State) {
        delegate?.didSelectState(state: state)
    }
}
