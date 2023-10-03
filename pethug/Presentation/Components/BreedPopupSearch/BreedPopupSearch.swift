//
//  PopupSearch.swift
//  pethug
//
//  Created by Raul Pena on 29/09/23.
//


import UIKit

protocol PopupSearchDelegate: AnyObject {
    func didTapCancell()
}

class BreedPopupSearch: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
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
//        collectionView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        collectionView.layer.borderColor = customRGBColor(red: 55, green: 239, blue: 143).cgColor
        collectionView.layer.borderWidth = 1
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
            case .breed:
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
        
        
        let titleViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<SearchBreedListCellConfiguration>, SearchBreed> { cell, _, model in
            //            cell.configure(with: model, delegate: self)
            cell.viewModel = model
        }
        
        
        let searchBreedMockVM = SearchBreed(breed: "Dachshund")
//        searchBreedMockVM.delegate = self
        
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
    func generatePetBreeds(total: Int) -> [Item] {
        var breeds = [Item]()
//        for number in 0...total {
//            let k = Int(arc4random_uniform(6))
//            breeds.append(.title(.init(breed: "joanna \(number)")))
//        }
//
        let dog_breeds = [
            "Labrador Retriever",
            "German Shepherd",
            "Golden Retriever",
            "Bulldog",
            "Beagle",
            "Poodle (Standard, Miniature, and Toy)",
            "Rottweiler",
            "Yorkshire Terrier",
            "Boxer",
            "Dachshund",
            "Shih Tzu",
            "Siberian Husky",
            "Great Dane",
            "Doberman Pinscher",
            "Australian Shepherd",
            "Miniature Schnauzer",
            "Cavalier King Charles Spaniel",
            "Chihuahua",
            "Shetland Sheepdog",
            "Border Collie",
            "Australian Cattle Dog",
            "Dalmatian",
            "Pug",
            "Boxer",
            "Miniature Pinscher",
            "American Bulldog",
            "English Bulldog",
            "Weimaraner",
            "Pembroke Welsh Corgi",
            "Bichon Frise",
            "Shiba Inu",
            "Alaskan Malamute",
            "Havanese",
            "Newfoundland",
            "Maltese",
            "Boston Terrier",
            "Vizsla",
            "Bernese Mountain Dog",
            "Staffordshire Bull Terrier",
            "Rhodesian Ridgeback",
            "Bullmastiff",
            "Bloodhound",
            "West Highland White Terrier (Westie)",
            "Scottish Terrier (Scottie)",
            "American Eskimo Dog",
            "Papillon",
            "Portuguese Water Dog",
            "Irish Wolfhound",
            "Great Pyrenees",
            "Border Terrier",
            "Akita",
            "Shetland Sheepdog",
            "Chow Chow",
            "American Staffordshire Terrier",
            "Collie (Rough or Smooth)",
            "Borzoi",
            "Cairn Terrier",
            "Afghan Hound",
            "Samoyed",
            "Whippet",
            "Bull Terrier",
            "Basenji",
            "Chinese Shar-Pei",
            "Newfoundland",
            "Basset Hound",
            "Australian Terrier",
            "Tibetan Mastiff",
            "Norwegian Elkhound",
            "Belgian Malinois",
            "Cocker Spaniel",
            "Staffordshire Bull Terrier",
            "Shih Tzu",
            "Scottish Terrier",
            "Soft Coated Wheaten Terrier",
            "Airedale Terrier",
            "Leonberger",
            "American Eskimo Dog",
            "Coton de Tulear",
            "Great Pyrenees",
            "Irish Terrier",
            "Cardigan Welsh Corgi",
            "Flat-Coated Retriever",
            "Belgian Tervuren",
            "Australian Terrier",
            "Anatolian Shepherd Dog",
            "American Water Spaniel",
            "Tibetan Terrier",
            "Clumber Spaniel",
            "Norwegian Elkhound",
            "Bearded Collie",
            "Irish Setter",
            "Japanese Chin",
            "Irish Water Spaniel",
            "Kuvasz",
            "Affenpinscher",
            "American Foxhound",
            "Sussex Spaniel",
            "Scottish Deerhound",
            "Saluki",
            "Belgian Laekenois",
            "Pyrenean Shepherd",
            "Plott Hound",
            "Norwegian Lundehund",
            "Greater Swiss Mountain Dog",
            "Icelandic Sheepdog",
            "Bluetick Coonhound",
            "Lagotto Romagnolo",
            "Swedish Vallhund",
            "Xoloitzcuintli (Mexican Hairless Dog)",
            "Norwegian Buhund",
            "Otterhound",
            "Portuguese Podengo",
            "Pumi",
            "Sloughi",
            "Curly-Coated Retriever",
            "American Hairless Terrier",
            "Rat Terrier",
            "Irish Red and White Setter",
            "Portuguese Sheepdog",
            "Belgian Sheepdog",
            "Dutch Shepherd",
            "Finnish Lapphund",
            "Shikoku",
            "Nova Scotia Duck Tolling Retriever",
            "Norwegian Lundehund",
            "Schipperke",
            "Tibetan Mastiff",
            "Sealyham Terrier",
            "Rat Terrier",
            "Petit Basset Griffon Vendéen",
            "Manchester Terrier",
            "Lowchen",
            "Icelandic Sheepdog",
            "Harrier",
            "Glen of Imaal Terrier",
            "Black and Tan Coonhound",
            "American Water Spaniel",
            "American Hairless Terrier",
            "Welsh Terrier",
            "Sussex Spaniel",
            "Sloughi",
            "Shiba Inu",
            "Redbone Coonhound",
            "Plott Hound",
            "Pharaoh Hound",
            "Norwegian Buhund",
            "Neapolitan Mastiff",
            "Manchester Terrier",
            "Manchester Terrier (Toy)",
            "Lowchen",
            "Leonberger",
            "Glen of Imaal Terrier",
            "Finnish Lapphund",
            "Dandie Dinmont Terrier",
            "Cirneco dell'Etna",
            "Cesky Terrier",
            "Bluetick Coonhound",
            "Biewer Terrier",
            "Beauceron",
            "Appenzeller Sennenhund",
            "American Staffordshire Terrier",
            "American Foxhound",
            "American English Coonhound",
            "Afghan Hound",
            "Affenpinscher",
            "Azawakh",
            "Australian Terrier",
            "Australian Cattle Dog",
            "Australian Kelpie",
            "Australian Shepherd"
        ]

        for breed in dog_breeds {
            breeds.append(.breed(.init(breed: breed)))
        }
        
        return breeds
    }
    
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
//        currentSnapData  = [.init(key: .pets, values: generatePet(total: 60))]
        currentSnapData  = [
            .init(key: .breed, values: generatePetBreeds(total: 20))
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
    

        

