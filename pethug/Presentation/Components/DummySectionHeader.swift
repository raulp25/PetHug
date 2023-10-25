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
         label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
         label.textAlignment = .center
         label.numberOfLines = 0
        return label
    }()
    var titleLabel2: UILabel = {
      let label = UILabel(withAutolayout: true)
       label.text = "Header mock"
       label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
       return label
   }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

