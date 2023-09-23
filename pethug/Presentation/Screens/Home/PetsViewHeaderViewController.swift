//
//  PetsViewHeader.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit

final class PetsViewHeaderViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "dog3")
        iv.tintColor = UIColor.systemPink.withAlphaComponent(0.7)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Animales"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(filterImageView)
        
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: sidePadding)
//        logoImageView.setDimensions(height: 50, width: 50)
        logoImageView.setDimensions(height: 60, width: 60)
//        logoImageView.layer.borderColor = UIColor.green.cgColor
//        logoImageView.layer.borderWidth = 1
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
        
        filterImageView.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: sidePadding)
        filterImageView.setDimensions(height: 30, width: 30)
    }
    
}
