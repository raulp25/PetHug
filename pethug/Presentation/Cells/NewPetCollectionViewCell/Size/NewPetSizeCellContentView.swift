//
//  NewPetSizeCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit

final class NewPetSizeCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Tamańo (No obligatorio)"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackSmall, hStackMedium, hStackLarge])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
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
    
    enum CurrentChecked: Int {
        case small = 1
        case medium = 2
        case large = 3
        case unset = 4
    }
    
    var currentButton: CurrentChecked = .unset
    var buttons: [UIButton] = []
    
    // MARK: - Properties
    private var currentConfiguration: NewPetSizeListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetSizeListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: NewPetSizeListCellConfiguration) {
        super.init(frame: .zero)
        buttons = [smallCheckMarkButton, mediumCheckMarkButton, largeCheckMarkButton]
        for (index, button) in buttons.enumerated() {
            button.tag = index + 1
        }
        // create the content view UI
        setup()
        
        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetSizeListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        guard let item = currentConfiguration.viewModel else { return }
        if item.size != nil {
            switch item.size {
            case .small:
                smallCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                smallCheckMarkButton.tintColor = .systemOrange
                setInitialCurrentButton(button: smallCheckMarkButton)
            case .medium:
                mediumCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                mediumCheckMarkButton.tintColor = .systemOrange
                setInitialCurrentButton(button: mediumCheckMarkButton)
            case .large:
                largeCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                largeCheckMarkButton.tintColor = .systemOrange
                setInitialCurrentButton(button: largeCheckMarkButton)
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
            right: rightAnchor
        )
        titleLabel.setHeight(16)
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor, bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 20
        )
        vStack.setHeight(105)
        
        for button in buttons {
            button.setHeight(height)
        }
    }
    
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
                    currentConfiguration.viewModel?.delegate?.sizeDidChange(size: nil)
                } else {
                    button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    button.tintColor = .systemOrange
                    currentButton = checked
                    
                    switch checked {
                    case .small:
                        currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .small)
                    case .medium:
                        currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .medium)
                    case .large:
                        currentConfiguration.viewModel?.delegate?.sizeDidChange(size: .large)
                    default:
                        print("")
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

