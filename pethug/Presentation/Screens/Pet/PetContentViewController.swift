//
//  PetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit

final class PetContentViewController: UIViewController {
    //MARK: - Private components
    private let headerView = PetViewHeaderViewController()
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    //// Poner el pageController en la view y anclar a derecha top y con el padding top que resulte mejor 
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    
    //MARK: - Internal properties
    var snapData: [SnapData]
    
    //MARK: - LifeCycle
    init(snapData: [SnapData]) {
        self.snapData = snapData
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        configureUI()
        configureDataSource()
        updateSnapShot()
        
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .gallery:
                print("dogs section")
                return .createPetLayout(for: .gallery)
            case .nameLocation:
                return .createPetLayout(for: .nameLocation)
            case .info:
                return .createPetLayout(for: .info)
            case .description:
                return .createPetLayout(for: .description)
            case .medical:
                return .createPetLayout(for: .medical)
            case .social:
                return .createPetLayout(for: .social)
            }
        }
        return layout
    }
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        
        let galleryCellRegistration = UICollectionView.CellRegistration<PetViewGalleryCollectionViewCell, String> { cell, _, model in
            cell.configure(with: model)
        }
        
        let nameLocationCellRegistration = UICollectionView.CellRegistration<PetViewNameLocationCollectionViewCell, NameLocationData> { cell, _, model in
            cell.configure(with: model)
        }
        
        let infoCellRegistration = UICollectionView.CellRegistration<PetViewInfoCollectionViewCell, InfoData> { cell, _, model in
            cell.configure(with: model)
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let  .image(url):
                return collectionView.dequeueConfiguredReusableCell(using: galleryCellRegistration, for: indexPath, item: url)
            case let  .nameLocation(data):
                return collectionView.dequeueConfiguredReusableCell(using: nameLocationCellRegistration, for: indexPath, item: data)
            case let  .info(data):
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration, for: indexPath, item: data)
            case let  .description(description):
                return collectionView.dequeueConfiguredReusableCell(using: galleryCellRegistration, for: indexPath, item: "url")
            case let  .medical(info):
                return collectionView.dequeueConfiguredReusableCell(using: galleryCellRegistration, for: indexPath, item: "rl")
            case let  .social(info):
                return collectionView.dequeueConfiguredReusableCell(using: galleryCellRegistration, for: indexPath, item: "ifno")
            }
            
        })
    }
    
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
//        snapData  = [.init(key: .pets, values: generatePet(total: 21))]
        
        snapshot = Snapshot()
        snapshot.appendSections(snapData.map {
            return $0.key
        })
        
        
        for datum in snapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Setup
    func configureUI() {
        
        add(headerView)
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
        
        view.addSubview(collectionView)
        collectionView.anchor(top: headerView.view.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}


