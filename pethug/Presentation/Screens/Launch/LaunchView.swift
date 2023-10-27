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
        iv.image = UIImage(named: "launch3")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let title: UILabel = {
       let label = UILabel(withAutolayout: true)
       label.attributedLightBoldColoredText(
           lightText: "Pet",
           boldText: "hug",
           colorRegularText: .black,
           colorBoldText: .white,
           fontSize: 38
       )
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
        backgroundColor = customRGBColor(red: 0, green: 171, blue: 187)
        
        addSubview(iconImage)
        addSubview(title)
        
        iconImage.center(
            inView: self,
            yConstant: -20
        )
        iconImage.setDimensions(height: 120, width: 120)
        
        title.centerX(
            inView: iconImage,
            topAnchor: iconImage.bottomAnchor,
            paddingTop: 5
        )
        
        self.iconImage.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.iconImage.alpha = 0

        UIView.animate(
            withDuration: 0.2,
            delay: 0.0, options: .curveEaseOut,
            animations: { [weak self] in
                self?.iconImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.iconImage.alpha = 1
            })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

