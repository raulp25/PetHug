//
//  DummyCellHeader.swift
//  pethug
//
//  Created by Raul Pena on 23/09/23.
//

import UIKit

class DummySectionHeader: UICollectionReusableView {
    
     var titleLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Header mock"
        label.textColor = .black.withAlphaComponent(0.8)
         label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
         label.textAlignment = .center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.borderColor = customRGBColor(red: 243, green: 243, blue: 243).cgColor
        layer.borderWidth = 2
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

