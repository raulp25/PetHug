//
//  PetViewHeaderViewController.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

//protocol PetViewHeaderDelegate: AnyObject {
//    func action()
//}

import UIKit

final class PetViewHeaderViewController: UIViewController {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Adopta"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    //MARK: - Private properties
//    weak var delegate: PetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
//        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
//        view.addSubview(filterImageView)
        
//        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: sidePadding)
//        logoImageView.setDimensions(height: 60, width: 60)
        
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
//
//        filterImageView.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: sidePadding)
//        filterImageView.setDimensions(height: 30, width: 30)
    }
    
}

