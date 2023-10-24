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
    
    private var maleDogFriendly: TextCheckbox? = nil
    private var femaleDogFriendly: TextCheckbox? = nil
    private var maleCatFriendly: TextCheckbox? = nil
    private var femaleCatFriendly: TextCheckbox? = nil

    
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
    }
    
    
    private func configureCellUI(with socialInfo: SocialInfo) {
        maleDogFriendly = TextCheckbox(
                                titleText: "Perro macho",
                                isChecked: socialInfo.maleDogFriendly,
                                font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                isClickable: true,
                                delegate: self
                            )
        femaleDogFriendly = TextCheckbox(
                                titleText: "Perro hembra",
                                isChecked: socialInfo.femaleDogFriendly,
                                font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                isClickable: true,
                                delegate: self
                            )
        maleCatFriendly = TextCheckbox(
                        titleText: "Gato macho",
                        isChecked: socialInfo.maleCatFriendly,
                        font: UIFont.systemFont(ofSize: 12, weight: .regular),
                        isClickable: true,
                        delegate: self
                    )
        femaleCatFriendly = TextCheckbox(
                        titleText: "Gato hembra",
                        isChecked: socialInfo.femaleCatFriendly,
                        font: UIFont.systemFont(ofSize: 12, weight: .regular),
                        isClickable: true,
                        delegate: self
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
    
}

extension NewPetSocialInfoCellContentView: TextCheckBoxDelegate {
    func didTapCheckBox() {
        
        let socialInfo = SocialInfo(maleDogFriendly: maleDogFriendly!.isChecked,
                                    femaleDogFriendly: femaleDogFriendly!.isChecked,
                                    maleCatFriendly: maleCatFriendly!.isChecked,
                                    femaleCatFriendly: femaleCatFriendly!.isChecked)
        
        currentConfiguration.viewModel?.delegate?.socialInfoChanged(to: socialInfo)
    }
}









