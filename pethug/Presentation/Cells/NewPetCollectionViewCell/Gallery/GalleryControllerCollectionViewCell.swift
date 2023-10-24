//
//  GalleryControllerCollectionViewCell.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol GalleryCellDelegate: AnyObject {
    func didTapCell(_ cell: NewPetGalleryCellContentView.Item)
}

final class GalleryControllerCollectionViewCell: UICollectionViewCell {
    //MARK: - Private components
    let petImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = customRGBColor(red: 0, green: 61, blue: 44)
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var editImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .black.withAlphaComponent(0.4)
        uv.layer.cornerRadius = 10.5
        uv.isUserInteractionEnabled = true
        return uv
    }()
    
    private let editImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "paintbrush.pointed.fill")
        iv.tintColor = UIColor.white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: - Internal properties
    weak var delegate: GalleryCellDelegate?
    private var galleryImage: GalleryImage? = nil
    
    //MARK: - LifeCycle
    func configure(with galleryImage: GalleryImage) {
        configureCellUI(with: galleryImage)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    private func configureCellUI(with galleryImage: GalleryImage) {
        if let image = galleryImage.image {
            petImage.image = image
            editImageContainer.isHidden = false
        } else if galleryImage.isEmpty {
            petImage.backgroundColor = customRGBColor(red: 230, green: 230, blue: 230)
        }
        
        self.galleryImage = galleryImage
    }
    
    override func prepareForReuse() {
        petImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        addGestureRecognizer(tapGesture)
        
        addSubview(petImage)
        addSubview(editImageContainer)
        editImageContainer.addSubview(editImage)
        
        petImage.fillSuperview()
        
        editImageContainer.anchor(
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingBottom: 5,
            paddingRight: 2
        )
        editImageContainer.setDimensions(height: 21, width: 21)
        editImageContainer.isHidden = true

        editImage.center(inView: editImageContainer)
        editImage.setDimensions(height: 12, width: 12)
    }
    
    //MARK: - Private actions
    @objc private func didTapCell() {
        delegate?.didTapCell(.image(galleryImage!))
    }

}

