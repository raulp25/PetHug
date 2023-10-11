//
//  NewPetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit
import Combine

protocol NewPetContentDelegate: AnyObject {
    func didEndUploading()
}

final class NewPetContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private let dummyView = DummyView()
//
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var viewModel: NewPetViewModel
    private var currentSnapData = [SnapData]() {
        didSet {
            print("cambio currentsnap data checar")
        }
    }
    private var cancellables = Set<AnyCancellable>()
    //MARK: - Internal properties
//    var snapData: [SnapData] {
//        didSet {
////            updateSnapShot()
//        }
//    }
//
    weak var delegate: NewPetContentDelegate?
    init(viewModel: NewPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit PetsContentViewController")
    }
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
        
        viewModel.stateSubject
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .success:
                    self?.delegate?.didEndUploading()
                    self?.dismiss(animated: true)
                default:
                    print("")
                }
                
            }.store(in: &cancellables)
    }
    
    
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
//        print(" (textFieldBottomY + intOne)  => \((textFieldBottomY + intOne)), > keyboardTopY ): \(keyboardTopY)")
//        print(" (textFieldBottomY + intOne) > keyboardTopY ): => \((textFieldBottomY + intOne) > keyboardTopY )")
        if (textFieldBottomY + intOne) > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            
            let contentOffset = collectionView.contentOffset
            let horizontalScrollPosition = contentOffset.y
            let height =
                UIScreen.main.bounds.size.height <= 870 ?
                    UIScreen.main.bounds.height / 0.86:
                        UIScreen.main.bounds.size.height <= 926 ?
                            UIScreen.main.bounds.height / 0.62:
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
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            
            guard let self else { fatalError() }
            
            let sideInsets = CGFloat(40)
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparators()
            
            switch section {
            case .name:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                return section
            case .gallery:
                let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparatorsWithInsets(leftInset: sideInsets, rightInset: sideInsets)
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                
                return section
            case .type:
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
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .size:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .age:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .activity:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .social:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .affection:
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
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .end:
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

        
        let newPetNameViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetNameListCellConfiguration>, NewPetName> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
        }
        
        let newPetGalleryViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGalleryListCellConfiguration>, NewPetGallery> { [weak self] cell, _, model in
            print("model gallery cell registration: => \(model)")
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.nagivagtion = self
        }
        
        let newPetTypeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetTypeListCellConfiguration>, NewPetType> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate  = self
            cell.viewModel?.type = self?.viewModel.typeState
        }
        
        let newPetBreedViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetBreedListCellConfiguration>, NewPetBreed> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.currentBreed = self?.viewModel.breedsState
            cell.viewModel?.petType = self?.viewModel.typeState
        }
        
        let newPetGenderViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGenderListCellConfiguration>, NewPetGender> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.gender = self?.viewModel.genderState
        }
        
        let newPetSizeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetSizeListCellConfiguration>, NewPetSize> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.size = self?.viewModel.sizeState
        }
        
        let newPetAgeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetAgeListCellConfiguration>, NewPetAge> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.age = self?.viewModel.ageState
        }
        
        let newPetActivityViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetActivityListCellConfiguration>, NewPetActivity> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.activityLevel = self?.viewModel.activityState
        }
        
        let newPetSocialViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetSocialListCellConfiguration>, NewPetSocial> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.socialLevel = self?.viewModel.socialState
        }
        
        let newPetAffectionViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetAffectionListCellConfiguration>, NewPetAffection> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.affectionLevel = self?.viewModel.affectionState
        }
        
        let newPetAddressViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetAddressListCellConfiguration>, NewPetAddress> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.address = self?.viewModel.addressState
        }
        
        let newPetInfoViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetInfoListCellConfiguration>, NewPetInfo> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.info = self?.viewModel.infoState
        }
        
        let newPetUploadViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetUploadListCellConfiguration>, NewPetUpload> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.buttonText = self?.viewModel.imagesToEditState.isEmpty ?? true ? "Subir" : "Acutalizar"
            cell.viewModel?.state = self?.viewModel.stateSubject
            cell.viewModel?.isFormValid = self?.viewModel.isValidSubject
            cell.viewModel?.delegate = self
        }
        
//        var nameMockVM = NewPetName(name: "Fernanda Sanchez")
//        nameMockVM.delegate = self
//
//        let galleryMockVM = NewPetGallery(imagesToEdit: [])
//
//        let typeMockVM = NewPetType(type: .dog)
//
//        let breedMockVM = NewPetBreed(currentBreed: "Golden Retriever")
        
//        let pet1 = Pet(id: "332", name: "joanna", age: 332, gender: .female, size: .small, breed: "dd", imagesUrls: [], type: .dog, address: .QuintanaRoo, isLiked: true)
//        switch (typeMockVM.type, pet1.type) {
//        case (.dog, .dog):
//            print("son iguales qwe DOG: =>")
//        case (.cat, .cat):
//            print("extra ///.2: =>")
//        case (.bird, .bird):
//            print("extra ///.2: =>")
//        case (.rabbit, .rabbit):
//            print("extra ///.2: =>")
//        default:
//            print("extra ///.2: =>")
//        }
        
//        if typeMockVM.type == .dog(.goldenRetriever) {
//            print("son iguales qwe: => \(typeMockVM.type == .dog(.goldenRetriever))")
//        } else {
//            print("no son iguales qwe")
//        }
//
//        let genderMockVM = NewPetGender(gender: .none)
//
//        let sizeMockVM = NewPetSize()
//
//        let ageMockVM = NewPetAge(age: nil)
//
//        let activityMockVM = NewPetActivity(activityLevel: nil)
//
//        let socialMockVM = NewPetSocial(socialLevel: nil)
//
//        let affectionMockVM = NewPetAffection(affectionLevel: nil)
//
//        let addressMockVM = NewPetAddress(address: nil)
//
//        let infoMockVM = NewPetInfo(info: nil)
//
//        let uploadMockVM = NewPetUpload()
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case .name(let nameVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetNameViewCellRegistration, for: indexPath, item: nameVM)
            case .gallery(let imagesVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetGalleryViewCellRegistration, for: indexPath, item: imagesVM)
            case .type(let typeVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetTypeViewCellRegistration, for: indexPath, item: typeVM)
            case .breed(let breedVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetBreedViewCellRegistration, for: indexPath, item: breedVM)
            case .gender(let genderVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetGenderViewCellRegistration, for: indexPath, item: genderVM)
            case .size(let sizeVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetSizeViewCellRegistration, for: indexPath, item: sizeVM)
            case .age(let ageVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAgeViewCellRegistration, for: indexPath, item: ageVM)
            case .activity(let activityVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetActivityViewCellRegistration, for: indexPath, item: activityVM)
            case .social(let socialVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetSocialViewCellRegistration, for: indexPath, item: socialVM)
            case .affection(let affectionVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAffectionViewCellRegistration, for: indexPath, item: affectionVM)
            case .address(let addressVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAddressViewCellRegistration, for: indexPath, item: addressVM)
            case .info(let infoVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetInfoViewCellRegistration, for: indexPath, item: infoVM)
            case .end(let endVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetUploadViewCellRegistration, for: indexPath, item: endVM)
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
        currentSnapData  = [
            .init(key: .name,      values: [.name(.init(name: viewModel.nameState))]),
            
            .init(key: .gallery,   values: [.gallery( .init(imagesToEdit: viewModel.imagesToEditState, imageService: ImageService()))]),
            
            .init(key: .type,      values: [.type(.init(type: viewModel.typeState))]),
            
            .init(key: .breed,     values: [.breed(.init(currentBreed: viewModel.breedsState))]),
            
            .init(key: .gender,    values: [.gender(.init(gender: viewModel.genderState))]),
            
            .init(key: .size,      values: [.size(.init(size: viewModel.sizeState))]),
            
            .init(key: .age,       values: [.age(.init(age: viewModel.ageState))]),
            
            .init(key: .activity,  values: [.activity(.init(activityLevel: viewModel.activityState))]),
            
            .init(key: .social,    values: [.social(.init(socialLevel: viewModel.socialState))]),
            
            .init(key: .affection, values: [.affection(.init(affectionLevel: viewModel.affectionState))]),
            
            .init(key: .address,   values: [.address(.init(address: viewModel.addressState))]),
            
            .init(key: .info,      values: [.info(.init(info: viewModel.infoState))]),
            
            .init(key: .end,       values: [.end(.init())])
            
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
    var counter = 0
}

extension NewPetContentViewController: NewPetNameDelegate {
    func textFieldDidChange(text: String) {
        let text = text.count > 0 ? text : nil
        viewModel.nameState = text
    }
}

extension NewPetContentViewController: NewPetGalleryDelegate {
    func galleryDidChange(images: [UIImage]) {
        viewModel.galleryState = images
    }
}

extension NewPetContentViewController: NewPetTypeDelegate {
    func typeDidChange(type: Pet.PetType) {
        if viewModel.typeState != type {
            viewModel.typeState = type
            viewModel.breedsState = nil
        }
        
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

extension NewPetContentViewController: NewPetAgeDelegate {
    func ageChanged(age: Int?) {
        viewModel.ageState = age
    }
}

extension NewPetContentViewController: NewPetActivityDelegate {
    func activityLevelChanged(to level: Int?) {
        viewModel.activityState = level
    }
}

extension NewPetContentViewController: NewPetSocialDelegate {
    func socialLevelChanged(to level: Int?) {
        viewModel.socialState = level
    }
}

extension NewPetContentViewController: NewPetAffectionDelegate {
    func affectionLevelChanged(to level: Int?) {
        viewModel.affectionState = level
    }
}

extension NewPetContentViewController: NewPetInfoDelegate {
    func textViewdDidChange(text: String) {
        print("cambio texto a: => \(text)")
        let text = text.count > 0 ? text : nil
        viewModel.infoState = text
    }
}

extension NewPetContentViewController: NewPetUploadDelegate {
    func didTapUpload() {
        Task {
            if viewModel.isEdit {
                await viewModel.updatePet()
            } else {
                await viewModel.createPet()
            }
        }
    }
}


extension NewPetContentViewController: UICollectionViewDelegate {
    
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
        searchController.breedsForType = viewModel.typeState
        let dummyNavigator = UINavigationController(rootViewController: searchController)
        dummyView.add(dummyNavigator)
        dummyNavigator.view.anchor(top: dummyView.view.safeAreaLayoutGuide.topAnchor, left: dummyView.view.leftAnchor, bottom: dummyView.view.keyboardLayoutGuide.topAnchor, right: dummyView.view.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        dummyNavigator.view.layer.cornerRadius = 15
        
        add(dummyView)
        dummyView.view.fillSuperview()

        dummyView.view.alpha = 0
        self.view.bringSubviewToFront(dummyView.view)
        self.collectionView.isUserInteractionEnabled = false
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
        
    }
}

//MARK: - Breed search Delegate
extension NewPetContentViewController: PopupSearchDelegate {
    
    func didSelectBreed(breed: String) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.dummyView.remove()
                self.collectionView.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.breedsState = breed
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.breed])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func didTapCancell() {
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


//MARK: - Address search Delegate
extension NewPetContentViewController: AddressPopupSearchDelegate {
    func didSelectState(state: Pet.State) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.dummyView.remove()
                self.collectionView.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
            })
        }
        
        viewModel.addressState = state
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.address])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func didTapCancellSearchAddress() {
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
        
        dummyView.view.alpha = 0
        self.view.bringSubviewToFront(dummyView.view)
        self.collectionView.isUserInteractionEnabled = false
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
    }
}





