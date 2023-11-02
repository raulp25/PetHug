//
//  NewPetSocialInfoCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 18/10/23.
//

import UIKit

final class NewPetSocialInfoCellContentView: UIView, UIContentView {
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
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private lazy var maleDogFriendly: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Perro macho",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    private lazy var femaleDogFriendly: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Perro hembra",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    private lazy var maleCatFriendly: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Gato macho",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    private lazy var femaleCatFriendly: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Gato hembra",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    // MARK: - Properties
    private var currentConfiguration: NewPetSocialInfoListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetSocialInfoListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetSocialInfoListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()
        
        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
//        translatesAutoresizingMaskIntoConstraints = true
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Functions
    private func apply(configuration: NewPetSocialInfoListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let item = currentConfiguration.viewModel else { return }
        configureCellUI(with: item.socialInfo)
        
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        addSubview(titleLabel)
        addSubview(vStack)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 20
        )
        
        vStack.setHeight(140)
        
        let textCheckBoxes = [
            maleDogFriendly,
            femaleDogFriendly,
            maleCatFriendly,
            femaleCatFriendly,
        ]
        
        for textCheckbox in textCheckBoxes {
            vStack.addArrangedSubview(textCheckbox)
        }
    }
    
    
    private func configureCellUI(with socialInfo: SocialInfo) {
        maleDogFriendly.isChecked   = socialInfo.maleDogFriendly
        femaleDogFriendly.isChecked = socialInfo.femaleDogFriendly
        maleCatFriendly.isChecked   = socialInfo.maleCatFriendly
        femaleCatFriendly.isChecked = socialInfo.femaleCatFriendly
    }
}

extension NewPetSocialInfoCellContentView: TextCheckBoxDelegate {
    func didTapCheckBox() {
        
        let socialInfo = SocialInfo(maleDogFriendly: maleDogFriendly.isChecked,
                                    femaleDogFriendly: femaleDogFriendly.isChecked,
                                    maleCatFriendly: maleCatFriendly.isChecked,
                                    femaleCatFriendly: femaleCatFriendly.isChecked)
        
        currentConfiguration.viewModel?.delegate?.socialInfoChanged(to: socialInfo)
    }
}










