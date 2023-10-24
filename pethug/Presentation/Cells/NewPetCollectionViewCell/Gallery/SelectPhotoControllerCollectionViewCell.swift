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
    private lazy var cameraImage: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "camera.fill"))
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
        cameraImage.image = UIImage(systemName: "camera.fill")
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
       setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cameraImage.image = nil
    }
    
    //MARK: - Actions
    @objc func didTapIcon(_ sender: UITapGestureRecognizer) {
        delegate?.didTapSelectPhoto()
    }
    
    //MARK: - Setup
    func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIcon))
        addGestureRecognizer(tapGesture)
        
        let dummyView = UIView()
        dummyView.backgroundColor = customRGBColor(red: 238, green: 238, blue: 238)
        dummyView.layer.cornerRadius = 10
        addSubview(dummyView)
        addSubview(cameraImage)
        
        dummyView.fillSuperview()
        
        cameraImage.center(inView: self)
        cameraImage.setDimensions(height: 40, width: 40)
    }
}

