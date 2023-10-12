//
//  NewPetTypeCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

final class NewPetTypeCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Tipo de animal"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackDog, hStackCat, hStackBird, hStackRabbit])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
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
    
    
    //MARK: - Internal properties
    
    // MARK: - Properties
    private var currentConfiguration: NewPetTypeListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetTypeListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: NewPetTypeListCellConfiguration) {
        super.init(frame: .zero)
        buttons = [dogCheckMarkButton, catCheckMarkButton, birdCheckMarkButton, rabbitCheckMarkButton]
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
    private func apply(configuration: NewPetTypeListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        //
        guard let item = currentConfiguration.viewModel else { return }
        if item.type != nil {
            switch item.type {
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
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 0
        )
        titleLabel.setHeight(16)
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 20
        )
        vStack.setHeight(150)
        
        for button in buttons {
            button.setHeight(height)
        }
    }
    
    enum CurrentChecked: Int {
        case dog = 1
        case cat = 2
        case bird = 3
        case rabbit = 4
    }
    
    var currentButton: CurrentChecked? = nil
    var buttons: [UIButton] = []
    
    @objc func didTapCheckMark(_ sender: UIButton) {
        guard let checked = CurrentChecked(rawValue: sender.tag) else {
            return
        }
        
        for button in buttons {
            if button == sender {
                    button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    button.tintColor = .systemOrange
                    currentButton = checked
            } else {
                button.setImage(UIImage(systemName: "square"), for: .normal)
                button.tintColor = .black
                currentButton = checked
            }
        }
        
        switch checked {
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
}

