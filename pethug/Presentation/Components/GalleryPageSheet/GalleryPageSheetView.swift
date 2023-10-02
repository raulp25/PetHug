//
//  CameraPageSheetViewController.swift
//  pethug
//
//  Created by Raul Pena on 02/10/23.
//

import UIKit

final class GalleryPageSheetView: UIViewController {
    //MARK: - Private components
    lazy private var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .clear
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
//        uv.isUserInteractionEnabled = true
//        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Origen"
        label.font = UIFont.systemFont(ofSize: 17.3, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.74)
        return label
    }()
    
    private lazy var hStackContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hStackCamera, hStackGallery])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = ((view.frame.width / 2) / 5) * 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCamera))
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tapGesture)
        return stack
    }()
    
    private lazy var hStackCamera: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cameraImage, cameraLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCamera))
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tapGesture)
        return stack
    }()
    
    private let cameraImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "camera.aperture"))
        iv.backgroundColor = .clear
        iv.tintColor = .orange
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "Camara"
        label.font = UIFont.systemFont(ofSize: 15.3, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.74)
        return label
    }()
    
    private lazy var hStackGallery: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [galleryImage, galleryLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGallery))
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tapGesture)
        return stack
    }()
    
    private let galleryImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "photo"))
        iv.backgroundColor = .clear
        iv.tintColor = .orange
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "Galeria"
        label.font = UIFont.systemFont(ofSize: 15.3, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.74)
        return label
    }()
    
    //MARK: - Internal properties
    var pageSheetHeight: CGFloat? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    
    //MARK: - Private Actions
     @objc private func didTapCamera() {
        print(": => tapped camera logo")
         dismiss(animated: true)
    }
    
     @objc private func didTapGallery() {
        print(": => tapped gallery logo")
         dismiss(animated: true)
    }
    
    //MARK: - Private Methods
    private func configure() {
        let paddingTop = (pageSheetHeight ?? 0) / 3
        
        view.addSubview(titleLabel)
        view.addSubview(hStackContainer)
        
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
        
        hStackContainer.centerX(inView: titleLabel, topAnchor: titleLabel.bottomAnchor, paddingTop: 30)
        
        cameraImage.setDimensions(height: 30, width: 30)
        
        galleryImage.setDimensions(height: 30, width: 30)
        
    }
    
}
