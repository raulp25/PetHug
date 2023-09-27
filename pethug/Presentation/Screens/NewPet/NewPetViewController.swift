//
//  NewPetViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

final class NewPetViewController: UIViewController {
    
    // MARK: - Private components
    private let contentVC = NewPetContentViewController()
    
    private lazy var xmarkImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapXmark))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var xmarkImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "xmark")
//      iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.tintColor = .systemPink
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapXmark))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    
    // MARK: - Internal properties
    weak var coordinator: NewPetCoordinator?
    
    //    init(viewModel: NewMessageViewModel) {
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 58, green: 91, blue: 144)
        
        view.addSubview(xmarkImageContainer)
        xmarkImageContainer.addSubview(xmarkImageView)
        add(contentVC)
        
        xmarkImageContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 15)
        xmarkImageContainer.setDimensions(height: 30, width: 30)
        
        xmarkImageView.center(inView: xmarkImageContainer)
        
        contentVC.view.anchor(top: xmarkImageContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
        contentVC.view.layer.borderColor = UIColor.green.cgColor
        contentVC.view.layer.borderWidth = 2
        
    }
    
    
    //MARK: - Actions
    @objc func didTapXmark() {
        print("clicked xmark: => ")
        dismiss(animated: true)
    }
    
}
