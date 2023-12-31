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
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Mis animales en adopción"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(titleLabel)
        
        view.addSubview(plusImageContainer)
        plusImageContainer.addSubview(plusImageView)
        
        view.sendSubviewToBack(plusImageContainer)
        view.sendSubviewToBack(plusImageView)
        
        
        titleLabel.centerX(
            inView: view, topAnchor:
                view.topAnchor,
            paddingTop: paddingTop
        )
        
        plusImageContainer.anchor(
            top: view.topAnchor,
            right: view.rightAnchor,
            paddingTop: 15,
            paddingRight: sidePadding
        )
        plusImageContainer.setDimensions(height: 32, width: 32)
        
        plusImageView.center(
            inView: plusImageContainer
        )
        plusImageView.setDimensions(height: 20, width: 20)
    }
    
    //MARK: - Actions
    @objc func didTapIcon() {
        delegate?.action()
    }
    
}

