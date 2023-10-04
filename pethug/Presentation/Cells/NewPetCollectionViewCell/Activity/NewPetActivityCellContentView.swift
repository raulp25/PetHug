//
//  NewPetActivityCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit

final class NewPetActivityCellContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "En una escala del 1 (menor) al 10 (mayor) indica que tan activo es el animal"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    private let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private lazy var subContainerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openKeyboard))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var hStackActivity: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [activityTextField, ageLabel])
        stack.backgroundColor = .white
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var activityTextField: UITextField = {
        let txtField = UITextField(frame: .zero)
        txtField.keyboardType = .numberPad
        txtField.textColor = .label
        txtField.tintColor = .orange
        txtField.textAlignment = .left
        txtField.font = .systemFont(ofSize: 16, weight: .regular)
        txtField.backgroundColor = .clear
//        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return txtField
    }()
    
    private let ageLabel: UILabel = {
       let label = UILabel()
        label.text = "años"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .medium)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    // MARK: - Properties
    private var currentConfiguration: NewPetActivityListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetActivityListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetActivityListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()

        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, let number = Int(text) else {
            currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: nil)
            textField.text = ""
            return
            
        }
        
        if text.count > 1 && text.hasPrefix("0") {
            let text = String(text.dropFirst())
            textField.text = text
            currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: Int(text))
            
        }
        
        if number > 10 {
            let text = "10"
            textField.text = text
            currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: Int(text))
        }
        
        if number < 1 {
            let text = "1"
            textField.text = text
            currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: Int(text))
        }
        
        if number >= 1 && number <= 10 {
            currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: number)
        }

    }
    
    @objc private func openKeyboard() {
        activityTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Functions
    private func apply(configuration: NewPetActivityListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let item = currentConfiguration.viewModel else { return }
        activityTextField.text = item.activityLevel != nil ? String(item.activityLevel!) : ""
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(containerView)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        containerView.addSubview(subContainerView)
        subContainerView.addSubview(activityTextField)
        
        containerView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 30)
        containerView.setHeight(40)
        
        subContainerView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, paddingLeft: 0)
        subContainerView.setWidth(50)
        subContainerView.layer.cornerRadius = 10
        
        activityTextField.center(inView: subContainerView)
        
        
    }
    
}

extension NewPetActivityCellContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activityTextField.resignFirstResponder()
    }
}




