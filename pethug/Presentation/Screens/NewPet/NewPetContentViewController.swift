//
//  NewPetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit
import Combine

struct NewPetDataManager: Hashable {
    var id =  UUID().uuidString
    var name: String? = nil
    var gallery: [String] = []
    var type: Pet.PetType? = nil
    var breed: String? = nil
    var gender: String? = nil
    var size: String? = nil
    var address: String? = nil
    var info: String? = nil
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    static func == (lhs: NewPetDataManager, rhs: NewPetDataManager) -> Bool {
        lhs.id == rhs.id
    }
}

class FormDataManager: Hashable, ObservableObject {
    @Published var formData: NewPetDataManager = NewPetDataManager()
    var id = UUID().uuidString
    var delegate: NewPetContentViewController?
    
    static func == (lhs: FormDataManager, rhs: FormDataManager) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(formData)
    }
}

class NewPetViewModel {
    
    enum State {
        case valid
        case invalid
    }
    
    
    //MARK: - Properties
    let state = CurrentValueSubject<State, Error>(.invalid)
    @Published var nameState: String? = nil
    @Published var galleryState: [UIImage] = []
    @Published var typeState: Pet.PetType? = nil
    @Published var breedState: String? = nil
    @Published var genderState: Pet.Gender? = nil
    @Published var sizeState: Pet.Size? = nil
    @Published var addressState: Pet.State? = nil
    @Published var infoState: String? = nil
    
    var breedsFor: Pet.PetType? = nil
    var isValid: Bool = false
//    private var statePublisher: AnyPublisher<(String?, String?), Never> {
//        return Publishers.CombineLatest($nameState, $addressState)
//            .removeDuplicates { prev, curr in
//                prev == curr
//            }.eraseToAnyPublisher()
//    }
    
    var formValidationState: AnyPublisher<NewPetViewModel.State, Never> {
        return Publishers.CombineLatest3(
            Publishers.CombineLatest3($nameState, $galleryState, $typeState),
            Publishers.CombineLatest3($breedState, $genderState, $sizeState),
            Publishers.CombineLatest($addressState, $infoState)
        )
        .map { nameGalleryType, breedGenderSize, addressInfo in
            let (name, gallery, type) = nameGalleryType
            let (breed, gender, size) = breedGenderSize
            let (address, info) = addressInfo
            
//            return [name, gallery]
            
            print("name inside validation publisher fn: => \(name)")
            print("info inside validation publisher fn: => \(info)")
            
            return self.validateForm(
                name: name,
                gallery: gallery,
                type: type,
                breed: breed,
                gender: gender,
                size: size,
                address: address,
                info: info
            )
            
        }
        .eraseToAnyPublisher()
    }
    
    func validateForm(
        name: String?,
        gallery: [UIImage],
        type: Pet.PetType?,
        breed: String?,
        gender: Pet.Gender?,
        size: Pet.Size?,
        address: Pet.State?,
        info: String?
    ) -> State{
        isValid = false
        guard let name = name else { return .invalid }
//        guard gallery.count > 0 else { return .invalid }
//        guard let type = type else { return .invalid }
//        guard let breed = breed else { return .invalid }
        //gender and size are optional
//        guard let address = address else { return .invalid }
        guard let info = info else { return .invalid }
        
        isValid = true
        return .valid
    }
    
}


final class NewPetContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private let dummyView = DummyView()
//
    //MARK: - Private properties
    private var isValid = CurrentValueSubject<Bool, Never>(false)
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var viewModel = NewPetViewModel()
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
    let PetDataManager = FormDataManager()
    
    private var cancellables = Set<AnyCancellable>()
    
//    let vc = PetsViewController(viewModel: .init(fetchPetsUC: FetchPets.composeFetchPetsUC()))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setupKeyboardHiding()
        navigationController?.navigationBar.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 50, right: 0)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dragInteractionEnabled = false
        configureDataSource()
        updateSnapShot()
        
        PetDataManager.delegate = self
        PetDataManager.$formData
            .handleThreadsOperator()
            .sink { newFormData in
                // React to changes in the formData globally
                // Example: updateUI(newFormData)
                print("form data changed: => \(newFormData)")
            }
            .store(in: &cancellables)
        
        viewModel.formValidationState.handleThreadsOperator()
            .sink { state in
            switch state {
            case .valid:
                print("is valid STATE FUCK: => VALID")
                self.isValid.send(true)
//                var snapshot = self.dataSource.snapshot()
//                snapshot.reloadSections([.end])
//                self.dataSource.apply(snapshot, animatingDifferences: false)
            case .invalid:
                self.isValid.send(false)
//                var snapshot = self.dataSource.snapshot()
//                snapshot.reloadSections([.end])
//                self.dataSource.apply(snapshot, animatingDifferences: false)
                print("is not valid STATE FUCK: NOT VALID=>")
            }
            }.store(in: &cancellables)
        
    }
    
    
//    @objc func didTapIcon() {
//        print("tap handlek: =>")
//        view.endEditing(true)
//    }
    
    private func setupKeyboardHiding(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
   
    var keyboardY = CGFloat(0)
    
    @objc func keyboardWillShow(sender: NSNotification) {
        print("keyboard will show lmr: => ")
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextView
        else {
            return
        }
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
    
        let convertedTextFieldFrame = view.convert(
            currentTextField.frame,
            from: currentTextField.superview
        )
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        let intOne:CGFloat = 10, intTwo: CGFloat = 150
        print(":UIScreen.main.bounds.height intone => \(UIScreen.main.bounds.height)")
        print(" (textFieldBottomY + intOne)  => \((textFieldBottomY + intOne)), > keyboardTopY ): \(keyboardTopY)")
        print(" (textFieldBottomY + intOne) > keyboardTopY ): => \((textFieldBottomY + intOne) > keyboardTopY )")
        if (textFieldBottomY + intOne) > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            
            let contentOffset = collectionView.contentOffset
            let horizontalScrollPosition = contentOffset.y
            let height =
                UIScreen.main.bounds.size.height <= 870 ?
            UIScreen.main.bounds.height / 0.86:
                        UIScreen.main.bounds.size.height <= 926 ?
                            UIScreen.main.bounds.height / 1 :
                                UIScreen.main.bounds.height / 1.1
            collectionView.setContentOffset(CGPoint(x: 0, y:  height), animated: true)
            collectionView.isScrollEnabled = false
        }
        
        if UIScreen.main.bounds.size.height <= 700 {
            collectionView.setContentOffset(CGPoint(x: 0, y: UIScreen.main.bounds.size.height / 0.68), animated: true)
            collectionView.isScrollEnabled = false
        }
    }
    
//
    @objc func keyboardWillHide(sender: NSNotification) {
        view.endEditing(true)
        collectionView.isScrollEnabled = true
        
//      Check if sender is UITextView
        guard let userInfo = sender.userInfo,
              let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let _ = UIResponder.currentFirst() as? UITextView
        else {
            return
        }
        
        if UIScreen.main.bounds.size.height <= 700 {
            collectionView.setContentOffset(CGPoint(x: 0, y: (UIScreen.main.bounds.size.height / 0.68) - 160), animated: true)
        }
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
            let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparators()
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
                let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparatorsWithInsets(leftInset: sideInsets, rightInset: sideInsets)
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
            case .breed:
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
            case .address:
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
                var listConfiguration: UICollectionLayoutListConfiguration = .createBaseEndListConfigWithSeparators()
                listConfiguration.separatorConfiguration.bottomSeparatorVisibility = .hidden
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
            cell.viewModel?.delegate = self
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetGalleryViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGalleryListCellConfiguration>, NewPetGallery> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.delegate = self
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetTypeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetTypeListCellConfiguration>, NewPetType> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.delegate  = self
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetBreedViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetBreedListCellConfiguration>, NewPetBreed> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.isEnabled = self.viewModel.breedsFor != nil ? true : false
            cell.viewModel?.breedsFor = self.viewModel.breedsFor
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetGenderViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGenderListCellConfiguration>, NewPetGender> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.delegate = self
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetSizeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetSizeListCellConfiguration>, NewPetSize> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.delegate = self
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetAddressViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetAddressListCellConfiguration>, NewPetAddress> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.delegate = self
//            cell.viewModel = self.PetDataManager
        }
        
        let newPetInfoViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetInfoListCellConfiguration>, NewPetInfo> { cell, _, model in
//            cell.configure(with: model, delegate: self)
//            cell.viewModel = model
//            cell.viewModel = self.PetDataManager
            cell.viewModel = model
            cell.viewModel?.delegate = self
        }
        
        let newPetUploadViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetUploadListCellConfiguration>, NewPetUpload> { cell, _, model in
//            cell.configure(with: model, delegate: self)
            cell.viewModel = model
            cell.viewModel?.isValid = self.isValid
//            cell.viewModel?.isValid = self.isValid
//            cell.viewModel = self.PetDataManager
        }
        
        let nameMockVM = NewPetName(name: "Fernanda Sanchez")
        nameMockVM.delegate = self
        
        let galleryMockVM = NewPetGallery(images: [])
        
        let typeMockVM = NewPetType(type: .dog(.goldenRetriever))
        
        let breedMockVM = NewPetBreed(breed: "Golden Retriever")
        
        let pet1 = Pet(id: "332", name: "joanna", age: 332, gender: .female, size: .small, breed: "dd", imageUrl: "dd", type: .dog(.goldenRetriever), address: .QuintanaRoo, isLiked: true)
        switch (typeMockVM.type, pet1.type) {
        case (.dog, .dog):
            print("son iguales qwe DOG: =>")
        case (.cat, .cat):
            print("extra ///.2: =>")
        case (.bird, .bird):
            print("extra ///.2: =>")
        case (.rabbit, .rabbit):
            print("extra ///.2: =>")
        default:
            print("extra ///.2: =>")
        }
        
//        if typeMockVM.type == .dog(.goldenRetriever) {
//            print("son iguales qwe: => \(typeMockVM.type == .dog(.goldenRetriever))")
//        } else {
//            print("no son iguales qwe")
//        }
//
        let genderMockVM = NewPetGender(gender: .none)
        
        let sizeMockVM = NewPetSize()
        
        let addressMockVM = NewPetAddress(address: .Queretaro)
        
        let infoMockVM = NewPetInfo(info: nil)
        
        let uploadMockVM = NewPetUpload()
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case .name:
                return collectionView.dequeueConfiguredReusableCell(using: newPetNameViewCellRegistration, for: indexPath, item: nameMockVM)
            case .gallery:
                return collectionView.dequeueConfiguredReusableCell(using: newPetGalleryViewCellRegistration, for: indexPath, item: galleryMockVM)
            case .type:
                return collectionView.dequeueConfiguredReusableCell(using: newPetTypeViewCellRegistration, for: indexPath, item: typeMockVM)
            case .breed:
                return collectionView.dequeueConfiguredReusableCell(using: newPetBreedViewCellRegistration, for: indexPath, item: breedMockVM)
            case .gender:
                return collectionView.dequeueConfiguredReusableCell(using: newPetGenderViewCellRegistration, for: indexPath, item: genderMockVM)
            case .size:
                return collectionView.dequeueConfiguredReusableCell(using: newPetSizeViewCellRegistration, for: indexPath, item: sizeMockVM)
            case .address:
                return collectionView.dequeueConfiguredReusableCell(using: newPetAddressViewCellRegistration, for: indexPath, item: addressMockVM)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: newPetInfoViewCellRegistration, for: indexPath, item: infoMockVM)
            case .end:
                return collectionView.dequeueConfiguredReusableCell(using: newPetUploadViewCellRegistration, for: indexPath, item: uploadMockVM)
            }
            
        })
        
//        dataSource.supplementaryViewProvider = { [weak self] collectionView, _, indexPath -> UICollectionReusableView? in
//            guard let self else {
//                return nil
//            }
//
//            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
//
//            switch section {
//            case .name:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .gallery:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .type:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .breed:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .gender:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .size:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .info:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            case .end:
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            }
//        }
    }
        
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
//        currentSnapData  = [.init(key: .pets, values: generatePet(total: 60))]
        currentSnapData  = [
            .init(key: .name, values: [.name]),
            .init(key: .gallery, values: [.gallery]),
            .init(key: .type, values: [.type]),
            .init(key: .breed, values: [.breed]),
            .init(key: .gender, values: [.gender]),
            .init(key: .size, values: [.size]),
            .init(key: .address, values: [.address]),
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
        let text = text.count > 0 ? text : nil
        viewModel.nameState = text
    }
}

extension NewPetContentViewController: NewPetGalleryDelegate {
    func galleryDidChange(images: [UIImage]) {
        
    }
}

extension NewPetContentViewController: NewPetTypeDelegate {
    func typeDidChange(type: Pet.PetType) {
        viewModel.typeState = type
        viewModel.breedsFor = type
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.breed])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension NewPetContentViewController: NewPetGenderDelegate {
    func genderDidChange(type: Pet.Gender?) {
        viewModel.genderState = type
    }
}

extension NewPetContentViewController: NewPetSizeDelegate {
    func sizeDidChange(size: Pet.Size?) {
        viewModel.sizeState = size
    }
}

extension NewPetContentViewController: NewPetInfoDelegate {
    func textViewdDidChange(text: String) {
        print("cambio texto a: => \(text)")
        let text = text.count > 0 ? text : nil
        viewModel.infoState = text
    }
}


//func presentSearchController() {}

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
        
extension NewPetContentViewController: NewPetBreedDelegate {
    func didTapBreedSelector() {
        let searchController = BreedPopupSearch()
        searchController.delegate = self
        let dummyNavigator = UINavigationController(rootViewController: searchController)
        dummyView.add(dummyNavigator)
        dummyNavigator.view.anchor(top: dummyView.view.safeAreaLayoutGuide.topAnchor, left: dummyView.view.leftAnchor, bottom: dummyView.view.keyboardLayoutGuide.topAnchor, right: dummyView.view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        dummyNavigator.view.layer.cornerRadius = 15
        
        add(dummyView)
        dummyView.view.fillSuperview()
        
        
        print("ejecuta async after: => ")
//        dummyView.view.isHidden = false
        dummyView.view.alpha = 0
        self.view.bringSubviewToFront(dummyView.view)
        self.collectionView.isUserInteractionEnabled = false
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
//            print("ejecuta async after: => ")
//            dummyView.view.isHidden = true
//            self.view.sendSubviewToBack(dummyView.view)
//            self.collectionView.isUserInteractionEnabled = true
//            self.view.layoutIfNeeded()
//        })
        
    }
}

extension NewPetContentViewController: PopupSearchDelegate, AddressPopupSearchDelegate {
    func didTapCancell() {
        print(":didTapCancell from parent => ")
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.dummyView.remove()
                self.collectionView.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
            })
        }
        
    }
}

extension NewPetContentViewController: NewPetAddressDelegate {
    func didTapAddressSelector() {
        let searchController = AddressPopupSearch()
        searchController.delegate = self
        let dummyNavigator = UINavigationController(rootViewController: searchController)
        dummyView.add(dummyNavigator)
        dummyNavigator.view.anchor(top: dummyView.view.safeAreaLayoutGuide.topAnchor, left: dummyView.view.leftAnchor, bottom: dummyView.view.keyboardLayoutGuide.topAnchor, right: dummyView.view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        dummyNavigator.view.layer.cornerRadius = 15
        
        add(dummyView)
        dummyView.view.fillSuperview()
        
        
        print("ejecuta async after: => ")
//        dummyView.view.isHidden = false
        dummyView.view.alpha = 0
        self.view.bringSubviewToFront(dummyView.view)
        self.collectionView.isUserInteractionEnabled = false
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
//            print("ejecuta async after: => ")
//            dummyView.view.isHidden = true
//            self.view.sendSubviewToBack(dummyView.view)
//            self.collectionView.isUserInteractionEnabled = true
//            self.view.layoutIfNeeded()
//        })
        
    }
}




