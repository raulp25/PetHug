//
//  Badge.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit

final class Badge: UIView {
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = .black
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var titleText: String = ""
    var captionText: String? = nil
    var iconImageName: String? = nil
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
     convenience init(
        titleText: String? = nil,
        captionText: String? = nil,
        iconImageName: String? = nil
     ) {
         self.init(frame: .zero)
         configureUI(titleText: titleText, captionText: captionText, iconImageName: iconImageName)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Config
    func configureUI(titleText: String? = nil, captionText: String? = nil, iconImageName: String? = nil) {
        backgroundColor = customRGBColor(red: 254, green: 246, blue: 235, alpha: 1)
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self, topAnchor: topAnchor, paddingTop: 5)
        titleLabel.text = titleText
        titleLabel.setHeight(20)
        
        if captionText != nil {
            addSubview(captionLabel)
            captionLabel.centerX(inView: self, topAnchor: titleLabel.bottomAnchor, paddingTop: 0)
            captionLabel.text = captionText
            captionLabel.setHeight(30)
        }
        
        if iconImageName != nil {
            addSubview(iconImageView)
            iconImageView.image = UIImage(systemName: iconImageName ?? "house")
            iconImageView.centerX(inView: self, topAnchor: titleLabel.bottomAnchor, paddingTop: 0)
            iconImageView.setDimensions(height: 25, width: 25)
        }
    }
    
    
}
