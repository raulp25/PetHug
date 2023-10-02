//
//  PetsViewHeader.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit

protocol PetsViewHeaderDelegate: AnyObject {
    func action()
}

final class PetsViewHeaderViewController: UIViewController {
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
        label.text = "Animales"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let filterImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //MARK: - Private properties
    weak var delegate: PetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(filterImageView)
        
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: sidePadding)
        logoImageView.setDimensions(height: 60, width: 60)
        
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
        
        filterImageView.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: sidePadding)
        filterImageView.setDimensions(height: 30, width: 30)
    }
    
}
