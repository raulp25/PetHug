//
//  FavoritesViewHeaderViewController.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

final class FavoritesViewHeaderViewController: UIViewController {
    //MARK: - Private components
    private lazy var logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "dog3")
        iv.tintColor = UIColor.systemPink.withAlphaComponent(0.7)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSingOut))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    @objc private func didTapSingOut() {
        try! AuthService().signOut()
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Favoritos"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    //MARK: - Private properties
    weak var delegate: PetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        titleLabel.centerX(
            inView: view,
            topAnchor: view.topAnchor,
            paddingTop: paddingTop
        )
        titleLabel.setWidth(150)
        
        logoImageView.anchor(
            top: view.topAnchor,
            right: view.rightAnchor,
            paddingTop: 0,
            paddingRight: sidePadding
        )
        logoImageView.setDimensions(height: 60, width: 70)
    }
    
}

