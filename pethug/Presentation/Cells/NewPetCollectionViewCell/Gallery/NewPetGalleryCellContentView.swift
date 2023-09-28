//
//  NewPetGalleryCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

final class NewPetGalleryCellContentView: UIView, UIContentView {
    
    
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private let titleLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Galería"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 12.3, weight: .bold)
        return label
    }()
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    
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
    
    // MARK: - Properties
    private var currentConfiguration: NewPetGalleryListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetGalleryListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: NewPetGalleryListCellConfiguration) {
        super.init(frame: .zero)

        // create the content view UI
        setup()

        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
        
        translatesAutoresizingMaskIntoConstraints = true
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(collectionView)
        let sideInsets = CGFloat(40)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: sideInsets)
        titleLabel.setHeight(14)
        
        containerView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 30)
        containerView.setDimensions(height: 90, width: 90)
        collectionView.fillSuperview()
        collectionView.contentInset = .init(top: 15, left: sideInsets, bottom: 15, right: 10)
        collectionView.backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        collectionView.showsHorizontalScrollIndicator = false
        configureDataSource()
        updateSnapShot()
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit NewPetGalleryContentView")
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetGalleryListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
//
        guard let item = currentConfiguration.viewModel else { return }
//        nameLabel.text = item.name
//        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        nameLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
//
//        imageView.configure(with: item.profileImageUrlString)
    }
    
    private func setup() {
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
    }
    
    //MARK: - CollectionView layout
//   We have the sectionProvider prop just in case
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .gallery:
                print("dogs section")
                return .createNewPetGalleryLayout()
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
        
///        FOR EDIT PET INSTEAD OF PASSING UIIMAGE directly, WE PASS A VIEWMODEL THAT HAS A IMAGEURLSTRING[String] AND A IMAGEFROMDEVICE[UIIMAGE] PRPERTYS and we
///       place the condition inside the cell if the image from device isnt nil we render with uiimage named
        let selectetPhotoViewCellRegistration = UICollectionView.CellRegistration<SelectPhotoControllerCollectionViewCell, String> { cell, _, model in
            cell.configure(delegate: self)
        }
        
        let galleryImageViewCellRegistration = UICollectionView.CellRegistration<GalleryControllerCollectionViewCell, UIImage> { cell, _, model in
            cell.configure(with: model)
        }
        
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let .image(image):
                if indexPath.row == 0 {
                    return collectionView.dequeueConfiguredReusableCell(using: selectetPhotoViewCellRegistration, for: indexPath, item: "nil")
                }
                return collectionView.dequeueConfiguredReusableCell(using: galleryImageViewCellRegistration, for: indexPath, item: image)
            }
            
        })
    }
        
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
        currentSnapData  = [.init(key: .gallery, values: [
            .image(UIImage(systemName: "pencil")!),
            .image(UIImage(named: "pr1")!),
            .image(UIImage(named: "pr2")!),
            .image(UIImage(named: "pr3")!),
            .image(UIImage(named: "pr4")!),
            .image(UIImage(named: "pr5")!),
            .image(UIImage(named: "pr6")!),
            .image(UIImage(named: "pr7")!),
            .image(UIImage(named: "pr8")!),
            .image(UIImage(named: "pr9")!),
            .image(UIImage(named: "pr10")!),
            .image(UIImage(named: "sal")!),
            .image(UIImage(named: "bull")!),
            .image(UIImage(named: "dog1")!),
            .image(UIImage(named: "dog3")!),
            .image(UIImage(named: "orange")!),
        ])]
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


extension NewPetGalleryCellContentView: SelectPhotoCellDelegate {
    ///Image multi picker
    func didTapSelectPhoto() {
    }
}
