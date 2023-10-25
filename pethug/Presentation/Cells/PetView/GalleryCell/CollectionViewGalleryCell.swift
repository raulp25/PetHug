//
//  CollectionViewGalleryCell.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit
import SDWebImage

protocol PetViewGalleryCellDelegate: AnyObject {
    func didTapCell(image: UIImage)
    func didPageChanged(to page: Int)
}

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
            collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
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
    var cachedPageNumber: Int = 0 {
        didSet {
            // When the cached page number is updated, this variable ensures that the current page
            // (currentPage) and the collectionView's scroll position are synchronized to the cached page.
            currentPage = cachedPageNumber
            collectionView.scrollToItem(at: IndexPath(item: cachedPageNumber, section: 0), at: .left, animated: false)
        }
    }
    weak var delegate: PetViewGalleryCellDelegate?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CollectionView layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
            guard let self else { fatalError() }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .image:
                let section: NSCollectionLayoutSection = .createPetLayout(for: .galleryImage)
                //Update the current page when scrolled
                section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
                    // Determine the current page based on the last visible item
                    let currentPage = visibleItems.last?.indexPath.row
                    
                    if let currentPage = currentPage{
                        self?.currentPage = currentPage
                        // We need this delay to ensure that the cached page number is used
                        // to scroll to the last cell seen by the user, preventing it from resetting to 0 when the
                        // main parent collectionView reset this nested collectonView, otherwise the visible cell will
                        // be the first one each time main parent collectionView reset this nested collectonView
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:  {
                            self?.delegate?.didPageChanged(to: currentPage)
                        })
                    }
                }

                return section
            }
        }
        return layout
    }
    
    //MARK: - CollectionView dataSource
    private func configureDataSource() { // Cell registration
        // imageCell
        let imageCellRegistration = UICollectionView.CellRegistration<PetViewImageCollectionViewCell, String> { [weak self]  cell, _, model in
            guard let self = self else { return }
            cell.configure(with: model)
            cell.delegate = self
        }
        // dataSource init
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

extension PetViewGalleryCollectionViewCell: PetViewImageCellDelegate {
    func didTapCell(image: UIImage) {
        delegate?.didTapCell(image: image)
    }
}
