//
//  FilterPetsSizeCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

final class FilterPetsSizeCellContentView: UIView, UIContentView {
    
    //MARK: - Private components
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Tamańo"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackAll, hStackSmall, hStackMedium, hStackLarge])
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
    
    private lazy var hStackSmall: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [smallLabel, smallCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let smallLabel: UILabel = {
        let label = UILabel()
        label.text = "Pequeńo"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var smallCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackMedium: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mediumLabel, mediumCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let mediumLabel: UILabel = {
        let label = UILabel()
        label.text = "Medio"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var mediumCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackLarge: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [largeLabel, largeCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let largeLabel: UILabel = {
        let label = UILabel()
        label.text = "Grande"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var largeCheckMarkButton: UIButton = {
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
        case small = 2
        case medium = 3
        case large = 4
    }
    private lazy var buttons: [UIButton] = {
        let buttons = [
            allCheckMarkButton,
            smallCheckMarkButton,
            mediumCheckMarkButton,
            largeCheckMarkButton
        ]
        return buttons
    }()
    private let sizeKey = FilterKeys.filterSize.rawValue
    
    // MARK: - Properties
    private var currentConfiguration: FilterPetsSizeListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? FilterPetsSizeListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsSizeListCellConfiguration) {
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
    
    // MARK: - Functions
    private func apply(configuration: FilterPetsSizeListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        guard let item = currentConfiguration.viewModel else { return }
        
        resetButtonsUI()
        updateButtonUIForSizeState(item.size)
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
        vStack.setHeight(150)
        
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
    private func updateButtonUIForSizeState(_ size: FilterSize) {
        switch size {
        case .all:
            allCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            allCheckMarkButton.tintColor = .systemOrange
        case .small:
            smallCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            smallCheckMarkButton.tintColor = .systemOrange
        case .medium:
            mediumCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            mediumCheckMarkButton.tintColor = .systemOrange
        case .large:
            largeCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            largeCheckMarkButton.tintColor = .systemOrange
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
            currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .all)
        case .small:
            currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .small)
        case .medium:
            currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .medium)
        case .large:
            currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .large)
        }
    }
    
    private func resetButtonsUI() {
        for button in buttons {
            button.setImage(UIImage(systemName: "square"), for: .normal)
            button.tintColor = .black
        }
    }
}


