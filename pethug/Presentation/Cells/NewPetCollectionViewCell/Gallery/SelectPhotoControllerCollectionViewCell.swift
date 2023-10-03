//
//  SelectPhotoControllerCollectionViewCell.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol SelectPhotoCellDelegate: AnyObject {
    func didTapSelectPhoto()
}

final class SelectPhotoControllerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    private lazy var petImage: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "camera.on.rectangle"))
        let k = Int(arc4random_uniform(6))
        iv.backgroundColor = .clear
        iv.tintColor = .orange
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: - Private properties
    private weak var delegate: SelectPhotoCellDelegate?
    
    //MARK: - LifeCycle
    func configure(delegate: SelectPhotoCellDelegate? = nil) {
        self.delegate = delegate
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIcon))
        addGestureRecognizer(tapGesture)
        
        let dummyView = UIView()
        dummyView.backgroundColor = customRGBColor(red: 238, green: 238, blue: 238)
        dummyView.layer.cornerRadius = 10
        addSubview(dummyView)
        addSubview(petImage)
        
        dummyView.fillSuperview()
        
        petImage.center(inView: self)
        petImage.setDimensions(height: 40, width: 40)
    }
    
    
    override func prepareForReuse() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func didTapIcon(_ sender: UITapGestureRecognizer) {
        delegate?.didTapSelectPhoto()
    }

}

