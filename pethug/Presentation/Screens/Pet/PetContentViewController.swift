//
//  PetContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit

final class PetContentViewController: UIViewController {
    
    //MARK: - Private components
    private let headerView = PetViewHeaderViewController()  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        add(headerView)
        headerView.view.setHeight(70)
        headerView.view.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop:
                UIScreen.main.bounds.size.height <= 700 ?
            40 :
                UIScreen.main.bounds.size.height <= 926 ?
            60 :
                75
        )
        
    }
    
}
