//
//  FilterPetsGenderCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

final class FilterPetsGenderCellContentView: UIView, UIContentView {
    
    //MARK: - Private components
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Genero (No obligatorio)"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackMale, hStackFemale])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        //        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private lazy var hStackMale: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [maleLabel, maleCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        //        stack.spacing = 15
        //        stack.layoutMargins = .init(top: 10, left: 20, bottom: 10, right: 20)
        //        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //    checkmark.square
    private let maleLabel: UILabel = {
        let label = UILabel()
        label.text = "Macho"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var maleCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        //        button.tag = CurrentChecked.dog.rawValue
        return button
    }()
    
    private lazy var hStackFemale: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [femaleLabel, femaleCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        //        stack.spacing = 15
        //        stack.layoutMargins = .init(top: 10, left: 20, bottom: 10, right: 20)
        //        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hembra"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var femaleCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        //        button.tag = CurrentChecked.cat.rawValue
        return button
    }()
    
    //MARK: - Private properties
    
    
    //MARK: - Internal properties
    
    // MARK: - Properties
    private var currentConfiguration: FilterPetsGenderListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? FilterPetsGenderListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsGenderListCellConfiguration) {
        super.init(frame: .zero)
        buttons = [maleCheckMarkButton, femaleCheckMarkButton]
        for (index, button) in buttons.enumerated() {
            button.tag = index + 1
        }
        // create the content view UI
        setup()
        
        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
        
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit NewPetGalleryContentView")
    }
    
    // MARK: - Functions
    private func apply(configuration: FilterPetsGenderListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        //
        guard let item = currentConfiguration.viewModel else { return }
        
        if item.gender != nil {
            switch item.gender {
            case .male:
                maleCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                maleCheckMarkButton.tintColor = .systemOrange
                setInitialCurrentButton(button: maleCheckMarkButton)
            case .female:
                femaleCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                femaleCheckMarkButton.tintColor = .systemOrange
                setInitialCurrentButton(button: femaleCheckMarkButton)
            case .none:
                print("")
            }
        }
    }
    
    private func setup() {
        let height = CGFloat(30)
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(vStack)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        titleLabel.setHeight(16)
        
        vStack.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 20)
        vStack.setHeight(75)
        
        for button in buttons {
            button.setHeight(height)
        }
    }
    
    enum CurrentChecked: Int {
        case male = 1
        case female = 2
        case unset = 3
    }
    
    var currentButton: CurrentChecked = .unset
    var buttons: [UIButton] = []
    
    @objc func didTapCheckMark(_ sender: UIButton) {
        guard let checked = CurrentChecked(rawValue: sender.tag) else {
            return
        }
        
        for button in buttons {
            if button == sender {
                if checked == currentButton {
                    button.setImage(UIImage(systemName: "square"), for: .normal)
                    button.tintColor = .black
                    currentButton = .unset
                    currentConfiguration.viewModel?.delegate?.genderDidChange(type: nil)
                } else {
                    button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    button.tintColor = .systemOrange
                    currentButton = checked
                    
                    switch checked {
                    case .male:
                        currentConfiguration.viewModel?.delegate?.genderDidChange(type: .male)
                    case .female:
                        currentConfiguration.viewModel?.delegate?.genderDidChange(type: .female)
                    default:
                        print(" ")
                    }
                }
            } else {
                button.setImage(UIImage(systemName: "square"), for: .normal)
                button.tintColor = .black
            }
        }
    }
    
    
    //MARK: - Private Methods
    func setInitialCurrentButton(button: UIButton) {
        if let checked = CurrentChecked(rawValue: button.tag) {
            currentButton = checked
        }
    }
    
}


