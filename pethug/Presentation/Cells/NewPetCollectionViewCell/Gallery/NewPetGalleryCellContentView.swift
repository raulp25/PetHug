//
//  NewPetGalleryCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit
import PhotosUI
import CropViewController

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
    
    private let captionLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Máximo 8 imagenes"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var work: DispatchWorkItem?
    private var editImageItem: NewPetGalleryCellContentView.Item!
    //MARK: - Internal properties
    private var currentSnapData: [SnapData] = [.init(key: .gallery, values: [
        .image(.init(image: UIImage(systemName: "pencil")!))
    ])]
    private var images: [UIImage] = [] {
        didSet {
            currentConfiguration.viewModel?.delegate?.galleryDidChange(images: images)
        }
    }
    
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
    
    // MARK: - LifeCycle
    init(configuration: NewPetGalleryListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()
        configureDataSource()
        updateSnapShot()
        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit NewPetGalleryContentView")
        work?.cancel()
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetGalleryListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        
        if !item.imagesToEdit.isEmpty {
            //Set the initial gray placeholder squares until loading the images finish
            if let gallerySectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }) {
                var array = [GalleryImage]()
                for _ in 0..<item.imagesToEdit.count {
                    array.append(GalleryImage(isEmpty: true))
                }
                
                currentSnapData[gallerySectionIndex].values.append(contentsOf: array.map({ .image($0) }))
                updateSnapShot()
            }
            
            //Load pet images
            work = DispatchWorkItem(block: {
                item.getImagetImagesSequentially(stringUrlArray: item.imagesToEdit) { [weak self] images in
                    if !images.isEmpty {
                        if let gallerySectionIndex = self?.currentSnapData.firstIndex(where: { $0.key == .gallery }) {
                            self?.currentSnapData[gallerySectionIndex].values.removeAll(where: { item in
                                switch item {
                                case let .image(galleryImage):
                                    return galleryImage.isEmpty == true
                                }
                            })
                            self?.images.append(contentsOf: images)
                            self?.currentSnapData[gallerySectionIndex].values.append(contentsOf: images.map({ .image(.init(image: $0)) }))
                            self?.updateSnapShot()
                        }
                    }
                }
            })
            
            DispatchQueue.main.async(execute: work!)
        }
    }
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        translatesAutoresizingMaskIntoConstraints = true
        isUserInteractionEnabled = true
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(captionLabel)
        
        let sideInsets = CGFloat(40)
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingLeft: sideInsets
        )
        titleLabel.setHeight(14)
        
        collectionView.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 10
        )
        
        collectionView.setHeight(90)
        
        captionLabel.anchor(
            top: collectionView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 10,
            paddingLeft: sideInsets,
            paddingBottom: 20
        )
        
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .gallery:
                return .createNewPetGalleryLayout()
            }
            
        }
        
        return layout
    }
    
    
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        let selectetPhotoViewCellRegistration = UICollectionView.CellRegistration<SelectPhotoControllerCollectionViewCell, String> { cell, _, model in
            cell.configure(delegate: self)
        }
        
        let galleryImageViewCellRegistration = UICollectionView.CellRegistration<GalleryControllerCollectionViewCell, GalleryImage> { cell, _, model in
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
        snapshot = Snapshot()
        snapshot.appendSections(currentSnapData.map {
            return $0.key
        })
        
        for datum in currentSnapData {
            snapshot.appendItems(datum.values, toSection: datum.key)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = true
        vc.resetAspectRatioEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continuar"
        vc.cancelButtonTitle = "Cancelar"
        vc.delegate = self
        //We need to dismiss the GalleryPageSheet that was previously presented by the viewmodel navigation
        currentConfiguration.viewModel?.navigation?.dismiss(animated: true, completion: {
            self.currentConfiguration.viewModel?.navigation?.present(vc, animated: true)
        })
    }

}

///MARK: - Camera / Gallery PageSheet
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
        
        currentConfiguration.viewModel?.navigation?.present(nav, animated: true, completion: nil)
    }
}

///MARK: - Did select camera / gallery action Delegate
extension NewPetGalleryCellContentView: GalleryPageSheetDelegate {
    func didTapCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        //We need to dismiss the GalleryPageSheet that was previously presented by the viewmodel navigation
        currentConfiguration.viewModel?.navigation?.dismiss(animated: true, completion: {
            self.currentConfiguration.viewModel?.navigation?.present(picker, animated: true)
        })
    }
    
    func didTapGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 8
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        //We need to dismiss the GalleryPageSheet that was previously presented by the viewmodel navigation
        currentConfiguration.viewModel?.navigation?.dismiss(animated: true, completion: {
            self.currentConfiguration.viewModel?.navigation?.present(phPicker, animated: true)
        })
    }
}


///MARK: - Delete / Edit image PageSheet
extension NewPetGalleryCellContentView: GalleryCellDelegate {
    func didTapCell(_ cell: Item) {
        guard let indexPath = dataSource.indexPath(for: cell) else { return }
        
        let height = CGFloat(153)
        
        let controller = EditGalleryImagePageSheetView()
        controller.pageSheetHeight = height
        controller.delegate = self
        controller.cellIndexPath = indexPath
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                return height
            })]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        currentConfiguration.viewModel?.navigation?.present(nav, animated: true, completion: nil)
               
    }
}

///MARK: - Did select delete / edit image action Delegate
extension NewPetGalleryCellContentView: EditGalleryImagePageSheetDelegate {
    func didTapDelete(cell indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            
            if let sectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }),
               let itemIndex = currentSnapData[sectionIndex].values.firstIndex(where: { $0 == item })
            {
                // Remove the item from currentSnapData
                currentSnapData[sectionIndex].values.remove(at: itemIndex)
                images.remove(at: itemIndex - 1)
                
                var snapshot = Snapshot()
                snapshot.appendSections([.gallery])
                snapshot.appendItems(currentSnapData[sectionIndex].values)
                dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    func didTapEdit(cell indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            
            editImageItem = item
            
            if let sectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }),
               let item = currentSnapData[sectionIndex].values.first(where: { $0 == item })
            {
                switch item {
                case .image(let image):
                    guard let image = image.image else { return }
                    showCrop(image: image)
                }
            }
        }
    }
}

//MARK: - CropViewController Delegate
extension NewPetGalleryCellContentView: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: false)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false)
        
        if let sectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }),
           let itemIndex = currentSnapData[sectionIndex].values.firstIndex(where: { $0 == editImageItem })
        {
            // Remove the item from currentSnapData
            let newImage: NewPetGalleryCellContentView.Item = .image(.init(image: image))
            currentSnapData[sectionIndex].values[itemIndex] = newImage
            images[itemIndex - 1] = image
            
            var snapshot = Snapshot()
            snapshot.appendSections([.gallery])
            snapshot.appendItems(currentSnapData[sectionIndex].values)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

//MARK: - Picker Camera Delegate
extension NewPetGalleryCellContentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        guard images.count < 8 else { return }
        
        if let gallerySectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }) {
            currentSnapData[gallerySectionIndex].values.append(.image(.init(image: image)))
            images.append(image)
            
            snapshot = dataSource.snapshot()
            snapshot.appendItems(currentSnapData[gallerySectionIndex].values, toSection: .gallery)
            dataSource.apply(snapshot, animatingDifferences: true)
            
        }
    }
}

///MARK: - PHPicker Gallery Delegate
extension NewPetGalleryCellContentView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        currentConfiguration.viewModel?.navigation?.dismiss(animated: true, completion: nil)
        
        guard let gallerySectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }) else { return }
        
        snapshot = dataSource.snapshot()
        
        func downloadNextImage(index: Int) {
            if index >= results.count || images.count >= 8 {
                snapshot.appendItems(currentSnapData[gallerySectionIndex].values, toSection: .gallery)
                DispatchQueue.main.async {[weak self] in
                    self?.dataSource.apply((self?.snapshot)!, animatingDifferences: true)
                }
                
            } else {
                let image = results[index]
                
                image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                    if let error = error {
                        print("error loading image object: => \(error)")
                        downloadNextImage(index: index + 1)
                    }
                    
                    if let image = object as? UIImage {
                        self?.currentSnapData[gallerySectionIndex].values.append(.image(.init(image: image)))
                        
                        self?.images.append(image)
                        
                        
                        downloadNextImage(index: index + 1)
                    }
                }
            }
        }
        
        downloadNextImage(index: 0)
        
    }
}
