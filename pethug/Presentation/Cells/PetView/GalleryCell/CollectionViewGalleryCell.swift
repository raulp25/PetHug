//
//  CollectionViewGalleryCell.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit
import SDWebImage


final class PetViewGalleryCollectionViewCell: UICollectionViewCell {
    //MARK: - Private components
    private lazy var collectionView: UICollectionView = .createDefaultCollectionView(layout: createLayout())
    private let pageControl = UIPageControl()
    
    //MARK: - Private properties
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
    private var snapData: [SnapData] = []{
        didSet {
            configureUI()
            configureDataSource()
            updateSnapShot()
        }
    }
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    //MARK: - Internal properties
    var images: [String]  = []{
        didSet{
            snapData = [.init(key: .image, values: images.map({ .image($0) }))]
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//
//    override func viewDidLayoutSubviews() {
//        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
//    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .image:
                let section: NSCollectionLayoutSection = .createPetLayout(for: .galleryImage)
                
                section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
                    let currentPage = visibleItems.last?.indexPath.row
                    
                    if let currentPage = currentPage{
                        self?.currentPage = currentPage
                    }
                }

                return section
            }
        }
        return layout
    }
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() {
        
        let imageCellRegistration = UICollectionView.CellRegistration<PetViewImageCollectionViewCell, String> { cell, _, model in
            cell.configure(with: model)
        }
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            
            switch model {
            case let  .image(url):
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: url)
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

        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        pageControl.numberOfPages = images.count
        pageControl.direction = .topToBottom
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.pageIndicatorTintColor = .orange.withAlphaComponent(0.5)
        
        pageControl.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
        
        pageControl.anchor(
            top: topAnchor,
            right: rightAnchor,
            paddingTop: 60,
            paddingRight: 5
        )
    }
    
}

