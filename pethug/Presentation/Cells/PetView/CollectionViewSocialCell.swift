//
//  CollectionViewSocialCell.swift
//  pethug
//
//  Created by Raul Pena on 08/10/23.
//

import UIKit

class PetViewSocialCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Amigable con"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private var maleDogFriendly: TextCheckbox? = nil
    private var femaleDogFriendly: TextCheckbox? = nil
    private var maleCatFriendly: TextCheckbox? = nil
    private var femaleCatFriendly: TextCheckbox? = nil

    
    //MARK: - LifeCycle
    func configure(with socialInfo: SocialInfo) {
        configureCellUI(with: socialInfo)
        configureConstraints()
    }
    
    override func prepareForReuse() {
        clearComponents()
    }
    
    private func configureCellUI(with socialInfo: SocialInfo) {
        maleDogFriendly = TextCheckbox(
                                titleText: "Perro macho",
                                isChecked: socialInfo.maleDogFriendly
                            )
        femaleDogFriendly = TextCheckbox(
                                titleText: "Perro hembra",
                                isChecked: socialInfo.femaleDogFriendly
                            )
        maleCatFriendly = TextCheckbox(
                        titleText: "Gato macho",
                        isChecked: socialInfo.maleCatFriendly
                    )
        femaleCatFriendly = TextCheckbox(
                        titleText: "Gato hembra",
                        isChecked: socialInfo.femaleCatFriendly
                    )
        
        let textCheckBoxes = [
            maleDogFriendly,
            femaleDogFriendly,
            maleCatFriendly,
            femaleCatFriendly,
        ]
        
        for textCheckbox in textCheckBoxes {
            if let textCheckbox = textCheckbox {
                vStack.addArrangedSubview(textCheckbox)
            }
            
        }
    }
    
    private func configureConstraints() {
        addSubview(titleLabel)
        addSubview(vStack)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor
        )
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 10
        )
    }
    
    private func clearComponents() {
        maleDogFriendly?.removeFromSuperview()
        femaleDogFriendly?.removeFromSuperview()
        maleCatFriendly?.removeFromSuperview()
        femaleCatFriendly?.removeFromSuperview()
        
        maleDogFriendly = nil
        femaleDogFriendly = nil
        maleCatFriendly = nil
        femaleCatFriendly = nil
    }
    
}

