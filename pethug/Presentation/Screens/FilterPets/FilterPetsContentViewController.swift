//
//  FilterPetsContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit
import Combine

final class FilterPetsContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private let headerView = FilterPetsViewHeaderViewController()
    private let dummyView = DummyView()
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var viewModel: FilterPetsViewModel = FilterPetsViewModel()
    
    private var snapData = [SnapData]() {
        didSet {
            print("cambio currentsnap data checar")
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        add(headerView)
        view.addSubview(collectionView)

        headerView.view.setHeight(70)
        headerView.view.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop:
                UIScreen.main.bounds.size.height <= 700 ?
                40 :
                    UIScreen.main.bounds.size.height <= 926 ?
                    60 :
                        75
        )
        headerView.delegate = self
        
        collectionView.anchor(top: headerView.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        
        hideKeyboardWhenTappedAround()
        setupKeyboardHiding()
        configureDataSource()
        updateSnapShot()
        
        viewModel.stateSubject
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .success:
                    self?.dismiss(animated: true)
                default:
                    print("")
                }

            }.store(in: &cancellables)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("✅ Deinit PetsContentViewController")
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
   
    //MARK: - Private Actions
    var keyboardY = CGFloat(0)
    
    @objc func keyboardWillShow(sender: NSNotification) {
        print("keyboard will show lmr: => ")
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField
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
//        print(":UIScreen.main.bounds.height intone => \(UIScreen.main.bounds.height)")
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
            UIScreen.main.bounds.height / 2.5:
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
    
    @objc func didTapXmark() {
        print("clicked xmark: => ")
        dismiss(animated: true)
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            
            guard let self else { fatalError() }
            
            let sideInsets = CGFloat(40)
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let listConfiguration: UICollectionLayoutListConfiguration = .createBaseListConfigWithSeparators()
            
            switch section {
            case .type:
                let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnv)
                section.contentInsets.top = 20
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
            case .ageRange:
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
        
        let newPetTypeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsTypeListCellConfiguration>, FilterPetsType> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate  = self
            cell.viewModel?.type = self?.viewModel.typeState
        }
        
        let newPetGenderViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsGenderListCellConfiguration>, FilterPetsGender> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.gender = self?.viewModel.genderState
        }
        
        let newPetSizeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsSizeListCellConfiguration>, FilterPetsSize> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.size = self?.viewModel.sizeState
        }
        
        let newPetAgeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsAgeListCellConfiguration>, FilterPetsAge> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
        }
        
        let newPetAddressViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsAddressListCellConfiguration>, FilterPetsAddress> { [weak self] cell, _, model in
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.address = self?.viewModel.addressState
        }
        
        
        let newPetUploadViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsSendListCellConfiguration>, FilterPetsSend> { [weak self] cell, _, model in
            cell.viewModel = model
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
            case .type(let typeVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetTypeViewCellRegistration, for: indexPath, item: typeVM)
            case .gender(let genderVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetGenderViewCellRegistration, for: indexPath, item: genderVM)
            case .size(let sizeVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetSizeViewCellRegistration, for: indexPath, item: sizeVM)
            case .ageRange(let ageVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAgeViewCellRegistration, for: indexPath, item: ageVM)
            case .address(let addressVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetAddressViewCellRegistration, for: indexPath, item: addressVM)
            case .end(let endVM):
                return collectionView.dequeueConfiguredReusableCell(using: newPetUploadViewCellRegistration, for: indexPath, item: endVM)
            }
            
        })
        
    }
        
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
        snapData  = [
            .init(key: .type,      values: [.type(.init(type: viewModel.typeState))]),
            
            .init(key: .gender,    values: [.gender(.init(gender: viewModel.genderState))]),
            
            .init(key: .size,      values: [.size(.init(size: viewModel.sizeState))]),
            
            .init(key: .ageRange,  values: [.ageRange(.init(ageRange: viewModel.ageRangeState))]),
            
            .init(key: .address,   values: [.address(.init(address: viewModel.addressState))]),
            
            .init(key: .end,       values: [.end(.init())])
            
        ]
        
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

extension FilterPetsContentViewController: FilterPetsViewHeaderDelegate {
    func didTapIcon() {
        navigationController?.popViewController(animated: true)
    }
}


extension FilterPetsContentViewController: FilterPetsTypeDelegate {
    func typeDidChange(type: Pet.FilterType) {
        if viewModel.typeState != type {
            viewModel.typeState = type
        }
    }
}

extension FilterPetsContentViewController: FilterPetsGenderDelegate {
    func genderDidChange(type: Pet.FilterGender?) {
        viewModel.genderState = type
    }
}

extension FilterPetsContentViewController: FilterPetsSizeDelegate {
    func sizeDidChange(size: Pet.FilterSize?) {
        viewModel.sizeState = size
    }
}

extension FilterPetsContentViewController: FilterPetsAgeDelegate {
    func ageChanged(ageRange: (Int, Int)?) {
        viewModel.ageRangeState = ageRange
    }
}


extension FilterPetsContentViewController: FilterPetsSendDelegate {
    func didTapSend() {
//        Task {
//            if viewModel.isEdit {
//                await viewModel.updatePet()
//            } else {
//                await viewModel.createPet()
//            }
//        }
    }
}


extension FilterPetsContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
        
//MARK: - Address search Delegate
extension FilterPetsContentViewController: FilterPetsAddressDelegate {
    func didTapAddressSelector() {
        let searchController = FilterAddressPopupSearch()
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
    
    func didTapAllCountry() {
        viewModel.addressState = .AllCountry
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.address])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension FilterPetsContentViewController: FilterAddressPopupSearchDelegate {
    func didSelectState(state: Pet.FilterState) {
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








