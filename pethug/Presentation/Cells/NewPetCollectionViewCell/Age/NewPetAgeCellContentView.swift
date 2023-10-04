//
//  NewPetAgeCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit

final class NewPetAgeCellContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Edad (max 25 años)"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    private let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private lazy var stackContainerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openKeyboard))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var hStackAge: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ageTextField, ageLabel])
        stack.backgroundColor = .white
        stack.axis = .horizontal
        stack.alignment = .center
//        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var ageTextField: UITextField = {
        let txtField = UITextField(frame: .zero)
        txtField.keyboardType = .numberPad
        txtField.textColor = .label
        txtField.tintColor = .orange
        txtField.textAlignment = .left
        txtField.font = .systemFont(ofSize: 16, weight: .regular)
        txtField.backgroundColor = .clear
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
    private var currentConfiguration: NewPetAgeListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetAgeListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetAgeListCellConfiguration) {
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
            currentConfiguration.viewModel?.delegate?.ageChanged(age: nil)
            textField.text = ""
            return
            
        }
        
        if text.count > 1 && text.hasPrefix("0") {
            let text = String(text.dropFirst())
            textField.text = text
            currentConfiguration.viewModel?.delegate?.ageChanged(age: Int(text))
            
        }
        
        if number > 25 {
            let text = "25"
            textField.text = text
            currentConfiguration.viewModel?.delegate?.ageChanged(age: Int(text))
        }
        
        if number < 0 {
            let text = "0"
            textField.text = text
            currentConfiguration.viewModel?.delegate?.ageChanged(age: Int(text))
        }
        
        if number >= 0 && number <= 10 {
            currentConfiguration.viewModel?.delegate?.ageChanged(age: number)
        }


    }
    
    @objc private func openKeyboard() {
        ageTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Functions
    private func apply(configuration: NewPetAgeListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let item = currentConfiguration.viewModel else { return }
        ageTextField.text = item.age != nil ? String(item.age!) : ""
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(containerView)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        containerView.addSubview(stackContainerView)
        stackContainerView.addSubview(hStackAge)
        containerView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 30)
        containerView.setHeight(40)
        stackContainerView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, paddingLeft: 0)
        stackContainerView.setWidth(80)
        stackContainerView.layer.cornerRadius = 10
        
        hStackAge.anchor(top: stackContainerView.topAnchor, left: stackContainerView.leftAnchor, bottom: stackContainerView.bottomAnchor, right: stackContainerView.rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        
    }
    
}

extension NewPetAgeCellContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ageTextField.resignFirstResponder()
    }
}



