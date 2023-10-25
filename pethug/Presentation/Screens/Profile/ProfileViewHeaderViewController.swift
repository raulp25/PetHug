//
//  File.swift
//  pethug
//
//  Created by Raul Pena on 23/10/23.
//

import UIKit

final class ProfileViewHeaderViewController: UIViewController {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "General"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    //MARK: - Private properties
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(titleLabel)
        
        titleLabel.center(
            inView: view,
            yConstant: paddingTop
        )
        titleLabel.setWidth(150)
    }
    
}


