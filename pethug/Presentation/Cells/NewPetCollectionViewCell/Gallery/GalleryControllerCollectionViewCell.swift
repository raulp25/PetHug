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
///Did tap row collectionview built in method
final class GalleryControllerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    let petImage: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
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
        uv.backgroundColor = customRGBColor(red: 240, green: 245, blue: 246)
        uv.layer.cornerRadius = 7
        uv.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
//        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private let editImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "paintbrush.pointed.fill")
        iv.tintColor = UIColor.red
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: - Private properties
//    private weak var delegate: GalleryCellDelegate?
    //MARK: - Internal properties
    weak var delegate: GalleryCellDelegate?
    private var galleryImage: GalleryImage? = nil
    //MARK: - LifeCycle
    func configure(with galleryImage: GalleryImage) {
//        self.delegate = delegate
        configureCellUI(with: galleryImage)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        addGestureRecognizer(tapGesture)
        
        addSubview(petImage)
//        addSubview(editImageContainer)
//        editImageContainer.addSubview(editImage)
        
        petImage.fillSuperview()
//        petImage.setHeight(frame.height / 2.6 * 2)
        
//        editImageContainer.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 5, paddingRight: 2)
//        editImageContainer.setDimensions(height: 17, width: 17)
//
//        editImage.center(inView: editImageContainer)
//        editImage.setDimensions(height: 15, width: 15)
        
    }
    
    
    private var work: DispatchWorkItem?
    
    private func configureCellUI(with galleryImage: GalleryImage) {
        print("gallery image en celda: => \(galleryImage)")
        if let image = galleryImage.image {
            petImage.image = image
        } else if galleryImage.isEmpty {
            petImage.backgroundColor = customRGBColor(red: 238, green: 238, blue: 238)
        }
        
        self.galleryImage = galleryImage
    }
    
    override func prepareForReuse() {
        petImage.image = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private actions
    @objc private func didTapCell() {
        delegate?.didTapCell(.image(galleryImage!))
    }

}

