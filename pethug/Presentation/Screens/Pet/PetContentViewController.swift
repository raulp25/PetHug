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

    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var cachedPageNumber = 0
    
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(NetworkMonitor.shared.isConnected) {
            alert(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
        }
    }
    
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch section {
            case .gallery:
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
        // Inside this gallery cell we have a nested collectionView because we have a UIPageControl anchored
        let galleryCellRegistration = UICollectionView.CellRegistration<PetViewGalleryCollectionViewCell, [String]> { [weak self] cell, _, model in
            guard let self = self else { return }
            cell.images = model
            cell.cachedPageNumber = cachedPageNumber
            cell.delegate = self
        }
        
        let nameLocationCellRegistration = UICollectionView.CellRegistration<PetViewNameLocationCollectionViewCell, NameLocationData> { cell, _, model in
            cell.configure(with: model)
        }
        
        let infoCellRegistration = UICollectionView.CellRegistration<PetViewInfoCollectionViewCell, InfoData> { cell, _, model in
            cell.configure(with: model)
        }
        
        let descriptionCellRegistration = UICollectionView.CellRegistration<PetViewDescriptionCollectionViewCell, String> { cell, _, model in
            cell.configure(with: model)
        }
        
        let medicalCellRegistration = UICollectionView.CellRegistration<PetViewMedicalCollectionViewCell, MedicalInfo> { cell, _, model in
            cell.configure(with: model)
        }
        
        let socialCellRegistration = UICollectionView.CellRegistration<PetViewSocialCollectionViewCell, SocialInfo> { cell, _, model in
            cell.configure(with: model)
        }
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let  .images(url):
                return collectionView.dequeueConfiguredReusableCell(using: galleryCellRegistration, for: indexPath, item: url)
            case let  .nameLocation(data):
                return collectionView.dequeueConfiguredReusableCell(using: nameLocationCellRegistration, for: indexPath, item: data)
            case let  .info(data):
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration, for: indexPath, item: data)
            case let  .description(description):
                return collectionView.dequeueConfiguredReusableCell(using: descriptionCellRegistration, for: indexPath, item: description)
            case let  .medical(info):
                return collectionView.dequeueConfiguredReusableCell(using: medicalCellRegistration, for: indexPath, item: info)
            case let  .social(info):
                return collectionView.dequeueConfiguredReusableCell(using: socialCellRegistration, for: indexPath, item: info)
            }
            
        })
    }
    
    // MARK: - Private methods
    private func updateSnapShot(animated: Bool = true) {
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
        
        collectionView.anchor(
            top: headerView.view.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
    //MARK: - Private methods
    private func savePhoto(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError err: Error?, contextInfo: UnsafeRawPointer) {
        if let err = err {
            alert(message: "Error al guardar imagen", title: "Error")
        } else {
            alert(message: "Imagen guardada exitosamente", title: "Listo")
        }
    }
    
    func showActionSheet(withTitle title: String, message: String, completion: @escaping(Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Guardar", style: .default, handler: { _ in completion(true) }))
        alert.addAction(.init(title: "Cancelar", style: .cancel, handler: { _ in completion(false) }))
        
        present(alert, animated: true, completion: nil)
    }

}

extension PetContentViewController: PetViewGalleryCellDelegate {
    func didTapCell(image: UIImage) {
        showActionSheet(withTitle: "Guardar imagen", message: "La imagen se guardara en tu galeria") { [weak self] save in
            if save {
                self?.savePhoto(image)
            }
        }
    }
    
    func didPageChanged(to page: Int) {
        cachedPageNumber = page
    }
}

