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
        label.text = "Genero"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackAll, hStackMale, hStackFemale])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        //        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private lazy var hStackAll: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [allLabel, allCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let allLabel: UILabel = {
        let label = UILabel()
        label.text = "Todos"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var allCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
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
    private let genderKey = FilterKeys.filterGender.rawValue
    
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
    
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsGenderListCellConfiguration) {
        super.init(frame: .zero)
        buttons = [allCheckMarkButton, maleCheckMarkButton, femaleCheckMarkButton]
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
        
        updateUIBasedOnUserDefaults()

    }
    
    private func setup() {
        let height = CGFloat(30)
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
        vStack.setHeight(112.5)
        
        for button in buttons {
            button.setHeight(height)
        }
    }
    
    //MARK: - Private actions
   private enum CurrentChecked: Int {
        case all = 1
        case male = 2
        case female = 3
    }
    
    private var buttons: [UIButton] = []
    
    @objc private func didTapCheckMark(_ sender: UIButton) {
        guard let checked = CurrentChecked(rawValue: sender.tag) else {
            return
        }
        
        updateButtonUIForSender(sender: sender, checked: checked)
        updateViewModel(checked: checked)
        saveKey(checked: checked)
    }
    
    
    //MARK: - Private methods
    private func updateUIBasedOnUserDefaults() {
        if let savedCheckedRawValue = UserDefaults.standard.value(forKey: genderKey) as? Int {
            if let savedChecked = CurrentChecked(rawValue: savedCheckedRawValue) {
                updateButtonUIForCheckedState(savedChecked)
            }
        } else {
            setAllCheckedAndSave()
        }
    }
    
    private func updateButtonUIForCheckedState(_ checked: CurrentChecked) {
        switch checked {
        case .all:
            allCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            allCheckMarkButton.tintColor = .systemOrange
        case .male:
            maleCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            maleCheckMarkButton.tintColor = .systemOrange
        case .female:
            femaleCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            femaleCheckMarkButton.tintColor = .systemOrange
        }
    }
    
    private func setAllCheckedAndSave() {
        saveKey(checked: .all)
        updateButtonUIForCheckedState(.all)
    }
    
    private func updateButtonUIForSender(sender: UIButton, checked: CurrentChecked) {
        for button in buttons {
            if button == sender {
                    button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    button.tintColor = .systemOrange
            } else {
                button.setImage(UIImage(systemName: "square"), for: .normal)
                button.tintColor = .black
            }
        }
        
    }
    
    private func updateViewModel(checked: CurrentChecked) {
        switch checked {
        case .all:
            currentConfiguration.viewModel?.delegate?.genderDidChange(type: .all)
        case .male:
            currentConfiguration.viewModel?.delegate?.genderDidChange(type: .male)
        case .female:
            currentConfiguration.viewModel?.delegate?.genderDidChange(type: .female)
        }
    }
    
    private func saveKey(checked: CurrentChecked) {
        UserDefaults.standard.set(checked.rawValue, forKey: genderKey)
    }
    
}


