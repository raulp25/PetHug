//
//  AddPetViewHeaderViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

protocol AddPetViewHeaderDelegate: AnyObject {
    func action()
}

final class AddPetViewHeaderViewController: UIViewController {
    //MARK: - Private components
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "dog1")
        iv.tintColor = UIColor.systemPink.withAlphaComponent(0.7)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Mis Animales en Adopcion"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var plusImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIcon))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var plusImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "plus")
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIcon))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    //MARK: - Private properties
    weak var delegate: AddPetViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let paddingTop: CGFloat = 20
        let sidePadding: CGFloat = 25
//        view.layer.borderColor = UIColor.blue.cgColor
//        view.layer.borderWidth = 1
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(plusImageContainer)
        view.bringSubviewToFront(plusImageContainer)
        plusImageContainer.addSubview(plusImageView)
        
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: sidePadding)
        logoImageView.setDimensions(height: 60, width: 60)
        
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
        
        plusImageContainer.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 15, paddingRight: sidePadding)
        plusImageContainer.setDimensions(height: 32, width: 32)
        
        plusImageView.center(inView: plusImageContainer)
        plusImageView.setDimensions(height: 20, width: 20)
    }
    
    //MARK: - Actions
    @objc func didTapIcon() {
        delegate?.action()
    }
    
}

