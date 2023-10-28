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
    
    private var snapData = [SnapData]()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Internal properties
    weak var coordinator: HomeTabCoordinator?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        hideKeyboardWhenTappedAround()
        configureDataSource()
        updateSnapShot()
        bind()
    }
    
    deinit {
        print("✅ Deinit FilterPetsContentViewController")
    }
    
    //MARK: - Setup
    private func setup() {
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        add(headerView)
        view.addSubview(collectionView)

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
        headerView.view.setHeight(70)
        headerView.delegate = self
        
        collectionView.anchor(
            top: headerView.view.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: 0,
            paddingRight: 0
        )
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
    }
    
    //MARK: - Bind
    func bind() {
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
    
   
    //MARK: - Private Actions}
    @objc func didTapXmark() {
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
        let newPetGenderViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsGenderListCellConfiguration>, FilterPetsGender> { [weak self] cell, _, model in
            guard let self = self else { return }
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.gender = self.viewModel.genderState
        }
        
        let newPetSizeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsSizeListCellConfiguration>, FilterPetsSize> { [weak self] cell, _, model in
            guard let self = self else { return }
            cell.viewModel = model
            cell.viewModel?.delegate = self
            cell.viewModel?.size = self.viewModel.sizeState
        }
        
        let newPetAgeViewCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell<FilterPetsAgeListCellConfiguration>, FilterPetsAge> { [weak self] cell, _, model in
            guard let self = self else { return }
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
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
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

extension FilterPetsContentViewController: FilterPetsGenderDelegate {
    func genderDidChange(gender: FilterGender) {
        if viewModel.genderState != gender {
            viewModel.genderState = gender
        }
    }
}

extension FilterPetsContentViewController: FilterPetsSizeDelegate {
    func sizeDidChange(size: FilterSize) {
        if viewModel.sizeState != size {
            viewModel.sizeState = size
        }
    }
}

extension FilterPetsContentViewController: FilterPetsAgeDelegate {
    func ageChanged(ageRange: FilterAgeRange) {
        viewModel.ageRangeState = ageRange
    }
}


extension FilterPetsContentViewController: FilterPetsSendDelegate {
    func didTapSend() {
        viewModel.saveFilterOptions()
        Task {
            await coordinator?.viewModel.fetchPetsWithFilter(options: viewModel.filterOptions, resetFilterQueries: true)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func didTapResetFields() {
        viewModel.resetState()
        updateSnapShot()
    }
}


extension FilterPetsContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let _ = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}

//MARK: - Address search Delegate
extension FilterPetsContentViewController: FilterPetsAddressDelegate {
    func didTapAddressSelector() {
        let searchController = FilterAddressPopupSearch()
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
    
    func didTapAllCountry() {
        viewModel.addressState = .AllCountry
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.address])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension FilterPetsContentViewController: FilterAddressPopupSearchDelegate {
    func didSelectState(state: FilterState) {
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








