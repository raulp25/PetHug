//
//  AddressPopupSearch.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol AddressPopupSearchDelegate: AnyObject {
    func didTapCancell()
}

class AddressPopupSearch: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    //MARK: - Private  components
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Nombre del animal / Título para darle mas duro a joanna por atras dale pa"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton.createTextButton(with: "cancel")
        btn.addTarget(self, action: #selector(didTapCancell), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Private properties
    private var inSearchMode: Bool {
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    
    //MARK: - Internal Properties
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
    
///    Use generics 4 receiving any type array and yeah
//    let data: T = [T]()
    var delegate: PopupSearchDelegate?
    var km = false
   
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
//        put the worker.cancel()
    }
    
    //MARK: - Private actions
    @objc func didTapCancell() {
        print(": => didTapCancell from popup")
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
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: cancelButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 23, paddingRight: 23)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        cancelButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 23, paddingBottom: 5, paddingRight: 23)
    }
    

    func didPresentSearchController(_ searchController: UISearchController) {
        print(": => didPresentSearchController()")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            searchController.searchBar.becomeFirstResponder()
        })
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            searchController.searchBar.resignFirstResponder()
//        })
        }
    
    //MARK: - CollectionView layout
//   We have the sectionProvider prop just in case
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            
            guard let self else { fatalError() }
            
            let sideInsets = CGFloat(0)
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparators()
//            listConfiguration.headerMode = .supplementary
            
            switch section {
            case .title:
                print("dogs section")
//                return .createPetsLayout()
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 0
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
        
        
        let titleViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<SearchAddressListCellConfiguration>, SearchAddress> { cell, _, model in
            //            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .title(address):
                return collectionView.dequeueConfiguredReusableCell(using: titleViewCellRegistration, for: indexPath, item: address)
            }
            
        })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath -> UICollectionReusableView? in
            guard let self else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .title:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
        }
        
    }
    func generatePetBreeds(total: Int) -> [Item] {
        var addresses = [Item]()
//        for number in 0...total {
//            let k = Int(arc4random_uniform(6))
//            addresses.append(.title(.init(address: "Queretaro")))
//        }
//
        let estadosMexicanos = [
            "Aguascalientes",
            "Baja California",
            "Baja California Sur",
            "Campeche",
            "Chiapas",
            "Chihuahua",
            "Coahuila",
            "Colima",
            "Durango",
            "Guanajuato",
            "Guerrero",
            "Hidalgo",
            "Jalisco",
            "Estado de México",
            "Michoacán",
            "Morelos",
            "Nayarit",
            "Nuevo León",
            "Oaxaca",
            "Puebla",
            "Querétaro",
            "Quintana Roo",
            "San Luis Potosí",
            "Sinaloa",
            "Sonora",
            "Tabasco",
            "Tamaulipas",
            "Tlaxcala",
            "Veracruz",
            "Yucatán",
            "Zacatecas"
        ]


        for estado in estadosMexicanos {
            addresses.append(.title(.init(address: estado)))
        }

        
        return addresses
    }
    
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
//        currentSnapData  = [.init(key: .pets, values: generatePet(total: 60))]
        currentSnapData  = [
            .init(key: .title, values: generatePetBreeds(total: 20))
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
    
}

//MARK: -  UISearchController updateSearchResults
extension AddressPopupSearch {
    func updateSearchResults(for searchController: UISearchController) {
//        print("DEGUB: FN UPDATE SEARCH RESULTS: => ")
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        if !searchText.isEmpty {
            km = true
        }
        
        if searchText.isEmpty && km == true {
            km = false
//            filteredUsers = []
//            tableView.reloadData()
            return
        }
        
        if km == true {
//            filteredUsers = users.filter({ $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText) })
//
//            tableView.reloadData()
        }
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        view.addSubview(tableView)
//        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor)
//        tableView.setWidth(view.frame.width - 15)ø
        
        
//        collectionView.removeFromSuperview()
    }
    
}


//extension PopupSearch: UISearchBarDelegate {
//
//}

//MARK: -  UITableViewDataSource
//extension SearchController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return inSearchMode ? filteredUsers.count : users.count
//        return 1
//    }
////
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
//
//        cell.userViewModel = UserCellViewModel(user: inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
//
//
//}


extension AddressPopupSearch: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print(":ejecuta didselect con metodo normal => ")
    //        collectionView.deselectItem(at: indexPath, animated: true)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        
//        print(":ejecuta didselect con datasource => \(counter)")
//        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
        


