//
//  PetViewHeaderViewController.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//


import UIKit

final class PetViewHeaderViewController: UIViewController {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Detalles"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
    }
    
}

