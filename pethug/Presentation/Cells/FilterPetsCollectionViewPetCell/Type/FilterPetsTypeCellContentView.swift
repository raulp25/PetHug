//
//  File.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

final class FilterPetsTypeCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.text = "Especificaciones"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Tipo de animal"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackAll, hStackDog, hStackCat, hStackBird, hStackRabbit])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
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
    
    private lazy var hStackDog: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dogLabel, dogCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let dogLabel: UILabel = {
        let label = UILabel()
        label.text = "Perro"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var dogCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackCat: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [catLabel, catCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let catLabel: UILabel = {
        let label = UILabel()
        label.text = "Gato"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var catCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackBird: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [birdLabel, birdCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let birdLabel: UILabel = {
        let label = UILabel()
        label.text = "Pajaro"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var birdCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackRabbit: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rabbitLabel, rabbitCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let rabbitLabel: UILabel = {
        let label = UILabel()
        label.text = "Conejo"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var rabbitCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Private properties
    private enum CurrentChecked: Int {
        case all = 1
        case dog = 2
        case cat = 3
        case bird = 4
        case rabbit = 5
    }
    private lazy var buttons: [UIButton] = {
        let buttons = [
            allCheckMarkButton,
            dogCheckMarkButton,
            catCheckMarkButton,
            birdCheckMarkButton,
            rabbitCheckMarkButton
        ]
        return buttons
    }()
    private let typeKey = FilterKeys.filterType.rawValue
    
    //MARK: - Internal properties
    
    // MARK: - Properties
    private var currentConfiguration: FilterPetsTypeListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? FilterPetsTypeListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsTypeListCellConfiguration) {
        super.init(frame: .zero)
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
    private func apply(configuration: FilterPetsTypeListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        guard let item = currentConfiguration.viewModel else { return }
        
        resetButtonsUI()
        updateButtonUIForTypeState(item.type)

    }
    
    private func setup() {
        let height = CGFloat(30)
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(headerLabel)
        addSubview(titleLabel)
        addSubview(vStack)
        
        headerLabel.centerX(
            inView: self,
            topAnchor: topAnchor
        )
        
        titleLabel.anchor(
            top: headerLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 30
        )
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 20
        )
        vStack.setHeight(187.5)
        
        for (index, button) in buttons.enumerated() {
            button.tag = index + 1
        }
        
        
        for button in buttons {
            button.setHeight(height)
        }
    }
    
    
    //MARK: - Private actions
    @objc private func didTapCheckMark(_ sender: UIButton) {
        guard let checked = CurrentChecked(rawValue: sender.tag) else { return }
        
        updateButtonUIForSender(sender: sender, checked: checked)
        updateViewModel(checked: checked)
    }
    
    
    
    //MARK: - Private methods
    private func updateButtonUIForTypeState(_ type: FilterType) {
        switch type {
        case .all:
            allCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            allCheckMarkButton.tintColor = .systemOrange
        case .dog:
            dogCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            dogCheckMarkButton.tintColor = .systemOrange
        case .cat:
            catCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            catCheckMarkButton.tintColor = .systemOrange
        case .bird:
            birdCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            birdCheckMarkButton.tintColor = .systemOrange
        case .rabbit:
            rabbitCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            rabbitCheckMarkButton.tintColor = .systemOrange
        }
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
            currentConfiguration.viewModel?.delegate?.typeDidChange(type: .all)
        case .dog:
            currentConfiguration.viewModel?.delegate?.typeDidChange(type: .dog)
        case .cat:
            currentConfiguration.viewModel?.delegate?.typeDidChange(type: .cat)
        case .bird:
            currentConfiguration.viewModel?.delegate?.typeDidChange(type: .bird)
        case .rabbit:
            currentConfiguration.viewModel?.delegate?.typeDidChange(type: .rabbit)
        }
    }
    
    private func resetButtonsUI() {
        for button in buttons {
            button.setImage(UIImage(systemName: "square"), for: .normal)
            button.tintColor = .black
        }
    }
}


