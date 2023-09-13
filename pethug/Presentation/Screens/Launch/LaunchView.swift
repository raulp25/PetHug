//
//  LaunchView.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

final class LaunchView: UIView {
    let iconImage: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.image = UIImage(named: "bull")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let title: UILabel = {
       let label = UILabel()
        label.text = "Pet Hug"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let subtitle: UILabel = {
       let label = UILabel()
        label.text = "Pet Adoption"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        backgroundColor = customRGBColor(red: 248, green: 111, blue: 14)
        
        addSubview(iconImage)
        iconImage.centerX(inView: self, topAnchor: topAnchor, paddingTop: (UIScreen.main.bounds.height / 4))
        iconImage.setDimensions(height: 230, width: 230)
        
        addSubview(title)
        title.centerX(inView: iconImage, topAnchor: iconImage.bottomAnchor, paddingTop: 20)
        
        addSubview(subtitle)
        subtitle.centerX(inView: title, topAnchor: title.bottomAnchor, paddingTop: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
