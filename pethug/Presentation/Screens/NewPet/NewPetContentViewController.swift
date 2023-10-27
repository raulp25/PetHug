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
    private let loadingView = LoadingViewController(spinnerColors: [customRGBColor(red: 255, green: 176, blue: 42)])
//
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var viewModel: NewPetViewModel
    private var currentSnapData = [SnapData]()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Internal properties
    weak var delegate: NewPetContentDelegate?
    
    //MARK: - LifeCycle
    init(viewModel: NewPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit NewPetContentViewController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupKeyboardHiding()
        setup()
        bind()
        configureDataSource()
        updateSnapShot()
    }
    
    //MARK: - Setup
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        collectionView.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: 0,
            paddingRight: 0
        )
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 50, right: 0)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dragInteractionEnabled = false
        
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel.stateSubject
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .success:
                    self?.delegate?.didEndUploading()
                    //Gives parent VC time to scrollTop collectionView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self?.dismiss(animated: true)
                    })
                case .loading:
                    self?.setLoadingScreen()
                case .error(_):
                    self?.renderError(message: "Hubo un error, intenta nuevamente")
                case .networkError:
                    self?.renderError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
                }
                
            }.store(in: &cancellables)
    }
    
    private func renderError(message: String, title: String = "") {
            removeLoadingScreen()
            alert(message: message, title: title)
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

        let intOne:CGFloat = 55, intTwo: CGFloat = 150
        
        if (textFieldBottomY + intOne) > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            
            let contentOffset = collectionView.contentOffset
            let horizontalScrollPosition = contentOffset.y
            //Responsive height measures
            let height =
            UIScreen.main.bounds.size.height <= 820 ?
                UIScreen.main.bounds.height / 0.37:
                    UIScreen.main.bounds.size.height <= 870 ?
                        UIScreen.main.bounds.height / 0.39:
                            UIScreen.main.bounds.size.height <= 900 ?
                                UIScreen.main.bounds.height / 0.42:
                                    UIScreen.main.bounds.size.height <= 926 ?
                                        UIScreen.main.bounds.height / 0.44:
                                            UIScreen.main.bounds.height / 0.44
            collectionView.setContentOffset(CGPoint(x: 0, y:  height), animated: true)
            collectionView.isScrollEnabled = false
        }
        //Responsive height measure for smaller devices (SE 3rd gen) - the same on keyboardWillHide
        if UIScreen.main.bounds.size.height <= 700 {
            collectionView.setContentOffset(CGPoint(x: 0, y: UIScreen.main.bounds.size.height / 0.30), animated: true)
            collectionView.isScrollEnabled = false
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        view.endEditing(true)
        collectionView.isScrollEnabled = true
        
        guard let userInfo = sender.userInfo,
              let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let _ = UIResponder.currentFirst() as? UITextView
        else {
            return
        }
        //Responsive height measure For smaller devices (SE 3rd gen)
        if UIScreen.main.bounds.size.height <= 700 {
            collectionView.setContentOffset(CGPoint(x: 0, y: (UIScreen.main.bounds.size.height / 0.30) - 160), animated: true)
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
            case .medicalInfo:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.bottom = 30
                section.contentInsets.leading = sideInsets
                section.contentInsets.trailing = sideInsets
                
                return section
            case .socialInfo:
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
        let newPetNameViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetNameListCellConfiguration>, NewPetName> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
        }
        // Inside this gallery cell we have a nested collectionView where we handle our delegate methods
        // to avoid making this VC super massive
        let newPetGalleryViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetGalleryListCellConfiguration>, NewPetGallery> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.navigation = self
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
        
        let newPetMedicalInfoViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetMedicalInfoListCellConfiguration>, NewPetMedicalInfo> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            if let self = self {
                cell.viewModel?.medicalInfo = self.viewModel.medicalInfoState
            }
        }
        
        let newPetSocialInfoViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<NewPetSocialInfoListCellConfiguration>, NewPetSocialInfo> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            if let self = self {
                cell.viewModel?.socialInfo = self.viewModel.socialInfoState
            }
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
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case .name(let nameVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetNameViewCellRegistration,        for: indexPath, item: nameVM)
            case .gallery(let imagesVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetGalleryViewCellRegistration,     for: indexPath, item: imagesVM)
            case .type(let typeVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetTypeViewCellRegistration,        for: indexPath, item: typeVM)
            case .breed(let breedVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetBreedViewCellRegistration,       for: indexPath, item: breedVM)
            case .gender(let genderVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetGenderViewCellRegistration,      for: indexPath, item: genderVM)
            case .size(let sizeVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetSizeViewCellRegistration,        for: indexPath, item: sizeVM)
            case .age(let ageVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAgeViewCellRegistration,         for: indexPath, item: ageVM)
            case .activity(let activityVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetActivityViewCellRegistration,    for: indexPath, item: activityVM)
            case .social(let socialVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetSocialViewCellRegistration,      for: indexPath, item: socialVM)
            case .affection(let affectionVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAffectionViewCellRegistration,   for: indexPath, item: affectionVM)
            case .medicalInfo(let medicalInfoVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetMedicalInfoViewCellRegistration, for: indexPath, item: medicalInfoVM)
            case .socialInfo(let socialInfoVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetSocialInfoViewCellRegistration,  for: indexPath, item: socialInfoVM)
            case .address(let addressVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAddressViewCellRegistration,     for: indexPath, item: addressVM)
            case .info(let infoVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetInfoViewCellRegistration,        for: indexPath, item: infoVM)
            case .end(let endVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetUploadViewCellRegistration,      for: indexPath, item: endVM)
            }
            
        })
    }
        
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
        currentSnapData  = [
            .init(key: .name,        values: [.name(.init(name: viewModel.nameState))]),
            
            .init(key: .gallery,     values: [.gallery( .init(imagesToEdit: viewModel.imagesToEditState, imageService: ImageService()))]),
            
            .init(key: .type,        values: [.type(.init(type: viewModel.typeState))]),
            
            .init(key: .breed,       values: [.breed(.init(currentBreed: viewModel.breedsState))]),
            
            .init(key: .gender,      values: [.gender(.init(gender: viewModel.genderState))]),
            
            .init(key: .size,        values: [.size(.init(size: viewModel.sizeState))]),
            
            .init(key: .age,         values: [.age(.init(age: viewModel.ageState))]),
            
            .init(key: .activity,    values: [.activity(.init(activityLevel: viewModel.activityState))]),
            
            .init(key: .social,      values: [.social(.init(socialLevel: viewModel.socialState))]),
            
            .init(key: .affection,   values: [.affection(.init(affectionLevel: viewModel.affectionState))]),
            
            .init(key: .medicalInfo, values: [.medicalInfo(.init(medicalInfo: viewModel.medicalInfoState))]),
            
            .init(key: .socialInfo,  values: [.socialInfo(.init(socialInfo: viewModel.socialInfoState))]),
            
            .init(key: .address,     values: [.address(.init(address: viewModel.addressState))]),
            
            .init(key: .info,        values: [.info(.init(info: viewModel.infoState))]),
            
            .init(key: .end,         values: [.end(.init())])
            
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
    
    private func setLoadingScreen() {
        view.isUserInteractionEnabled = false
        
        add(loadingView)
        view.bringSubviewToFront(loadingView.view)
        
        loadingView.view.fillSuperview()
        loadingView.view.backgroundColor = customRGBColor(red: 247, green: 247, blue: 247, alpha: 0.5)
        
        
        let topIndexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: topIndexPath, at: .top, animated: true)
        
    }
    
    private func removeLoadingScreen() {
        loadingView.remove()
        view.isUserInteractionEnabled = true
        
    }
}
//MARK: - Cells protocols
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

extension NewPetContentViewController: NewPetMedicalInfoDelegate {
    func medicalInfoChanged(to newMedicalInfo: MedicalInfo) {
        viewModel.medicalInfoState = newMedicalInfo
    }
}

extension NewPetContentViewController: NewPetSocialInfoDelegate {
    func socialInfoChanged(to newSocialInfo: SocialInfo) {
        viewModel.socialInfoState = newSocialInfo
    }
}

extension NewPetContentViewController: NewPetInfoDelegate {
    func textViewdDidChange(text: String) {
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

//MARK: - UICollectionViewDelegate
extension NewPetContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let _ = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}

//MARK: - NewPetBreedDelegate
extension NewPetContentViewController: NewPetBreedDelegate {
    //Opens breeds list modal
    func didTapBreedSelector() {
        let searchController = BreedPopupSearch()
        searchController.delegate = self
        searchController.breedsForType = viewModel.typeState
        
        let dummyNavigator = UINavigationController(rootViewController: searchController)
        
        add(dummyView)
        self.view.bringSubviewToFront(dummyView.view)
        dummyView.add(dummyNavigator)

        dummyView.view.fillSuperview()
        dummyView.view.alpha = 0
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        
        dummyNavigator.view.anchor(
            top: dummyView.view.safeAreaLayoutGuide.topAnchor,
            left: dummyView.view.leftAnchor,
            bottom: dummyView.view.keyboardLayoutGuide.topAnchor,
            right: dummyView.view.rightAnchor,
            paddingTop: 50,
            paddingLeft: 30,
            paddingBottom: 30,
            paddingRight: 30
        )
        dummyNavigator.view.layer.cornerRadius = 15
        
        self.collectionView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
    }
    
    // User selected unknown breed
    func didTapUnkownedBreed() {
        viewModel.breedsState = "Mestizo"
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.breed])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: - BreedPopupSearchDelegate - Breed search results
extension NewPetContentViewController: BreedPopupSearchDelegate {
    // User selected a breed
    func didSelectBreed(breed: String) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self?.dummyView.remove()
                self?.collectionView.isUserInteractionEnabled = true
                self?.view.layoutIfNeeded()
            })
        }
        
        viewModel.breedsState = breed
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.breed])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    // Cancelled search
    func didTapCancell() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
            self?.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self?.dummyView.remove()
                self?.collectionView.isUserInteractionEnabled = true
                self?.view.layoutIfNeeded()
            })
        }
        
    }
}


//MARK: - NewPetAddressDelegate
extension NewPetContentViewController: NewPetAddressDelegate {
    //Opens addresses list modal
    func didTapAddressSelector() {
        let searchController = AddressPopupSearch()
        searchController.delegate = self
        
        let dummyNavigator = UINavigationController(rootViewController: searchController)
        
        add(dummyView)
        self.view.bringSubviewToFront(dummyView.view)
        dummyView.add(dummyNavigator)
        
        dummyView.view.fillSuperview()
        dummyView.view.alpha = 0
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        
        dummyNavigator.view.anchor(
            top: dummyView.view.safeAreaLayoutGuide.topAnchor,
            left: dummyView.view.leftAnchor,
            bottom: dummyView.view.keyboardLayoutGuide.topAnchor,
            right: dummyView.view.rightAnchor,
            paddingTop: 50,
            paddingLeft: 30,
            paddingBottom: 30,
            paddingRight: 30
        )
        dummyNavigator.view.layer.cornerRadius = 15
        
        self.collectionView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
    }
}
//MARK: - AddressPopupSearchDelegate - Address search results
extension NewPetContentViewController: AddressPopupSearchDelegate {
    // User selected an address
    func didSelectState(state: Pet.State) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self?.dummyView.remove()
                self?.collectionView.isUserInteractionEnabled = true
                self?.view.layoutIfNeeded()
            })
        }
        
        viewModel.addressState = state
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.address])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    // Cancelled search
    func didTapCancellSearchAddress() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [weak self] in
            self?.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self?.dummyView.remove()
                self?.collectionView.isUserInteractionEnabled = true
                self?.view.layoutIfNeeded()
            })
        }
        
    }
}





