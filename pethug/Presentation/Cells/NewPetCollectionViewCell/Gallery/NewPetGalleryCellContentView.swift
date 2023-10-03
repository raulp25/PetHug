//
//  NewPetGalleryCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit
import PhotosUI

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
        isUserInteractionEnabled = true
        addSubview(titleLabel)
        addSubview(collectionView)
        
        let sideInsets = CGFloat(40)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: sideInsets)
        titleLabel.setHeight(14)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 20)
        collectionView.setHeight(90)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
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
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
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
            cell.delegate = self
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
//            .image(UIImage(named: "pr2")!),
//            .image(UIImage(named: "pr3")!),
//            .image(UIImage(named: "pr4")!),
//            .image(UIImage(named: "pr5")!),
//            .image(UIImage(named: "pr6")!),
//            .image(UIImage(named: "pr7")!),
//            .image(UIImage(named: "pr8")!),
//            .image(UIImage(named: "pr9")!),
//            .image(UIImage(named: "pr10")!),
//            .image(UIImage(named: "sal")!),
//            .image(UIImage(named: "bull")!),
//            .image(UIImage(named: "dog1")!),
//            .image(UIImage(named: "dog3")!),
//            .image(UIImage(named: "orange")!),
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

///MARK: - Camera / Gallery select PageSheet
extension NewPetGalleryCellContentView: SelectPhotoCellDelegate {
    func didTapSelectPhoto() {
        
        let height = CGFloat(153)
        
        let controller = GalleryPageSheetView()
        controller.pageSheetHeight = height
        controller.delegate = self
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                return height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        currentConfiguration.viewModel?.nagivagtion?.present(nav, animated: true, completion: nil)
    }
}

///MARK: - Did select camera / gallery Delegate
extension NewPetGalleryCellContentView: GalleryPageSheetDelegate {
    func didTapCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        currentConfiguration.viewModel?.nagivagtion?.dismiss(animated: true, completion: {
            self.currentConfiguration.viewModel?.nagivagtion?.present(picker, animated: true)
        })
    }
    
    func didTapGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 8
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        currentConfiguration.viewModel?.nagivagtion?.dismiss(animated: true, completion: {
            self.currentConfiguration.viewModel?.nagivagtion?.present(phPicker, animated: true)
        })
    }
}


///MARK: - Delete / Edit image select PageSheet
extension NewPetGalleryCellContentView: GalleryCellDelegate {
    func didTapCell(_ cell: Item) {
        guard let item = dataSource.indexPath(for: cell) else { return }
        
        let height = CGFloat(153)
        
        let controller = EditGalleryImagePageSheetView()
        controller.pageSheetHeight = height
        controller.delegate = self
        controller.cellIndexPath = item
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                return height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        currentConfiguration.viewModel?.nagivagtion?.present(nav, animated: true, completion: nil)
               
    }
}

///MARK: - Did select delete / edit image Delegate
extension NewPetGalleryCellContentView: EditGalleryImagePageSheetDelegate {
    func didTapDelete(cell indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([item])
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func didTapEdit() {
        //TODO We'll need a third party to crop "edit" the images
    }
}


//MARK: - Picker Camera
extension NewPetGalleryCellContentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        if let gallerySectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }) {
            currentSnapData[gallerySectionIndex].values.append(.image(image))
            
            snapshot = dataSource.snapshot()
            snapshot.appendItems(currentSnapData[gallerySectionIndex].values, toSection: .gallery)
            dataSource.apply(snapshot, animatingDifferences: true)
            
           }
    }
}

///MARK: - Picker Gallery
extension NewPetGalleryCellContentView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        currentConfiguration.viewModel?.nagivagtion?.dismiss(animated: true, completion: nil)
        
        guard let gallerySectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }) else { return }
        
        let dispatchGroup = DispatchGroup()
        
        snapshot = dataSource.snapshot()
        
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let error = error {
                    print("error loading image object: => \(error)")
                }
                
                if let image = object as? UIImage {
                    self?.currentSnapData[gallerySectionIndex].values.append(.image(image))
                    self?.snapshot.appendItems((self?.currentSnapData[gallerySectionIndex].values)!, toSection: .gallery)
                    dispatchGroup.leave()
                } else {
                    dispatchGroup.leave()
                }
                
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            DispatchQueue.main.async {[weak self] in
                self?.dataSource.apply((self?.snapshot)!, animatingDifferences: true)
            }
        }
        
    }
}
