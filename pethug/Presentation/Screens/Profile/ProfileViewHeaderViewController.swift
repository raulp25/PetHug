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
        label.font = UIFont.systemFont(ofSize: 35, weight: .light)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    //MARK: - Private properties
    weak var delegate: FilterPetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapChevron() {
        delegate?.didTapIcon()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 20
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(titleLabel)
        
        titleLabel.centerY(
            inView: view,
            leftAnchor: view.leftAnchor,
            paddingLeft: 25
        )
        
    }
    
}


