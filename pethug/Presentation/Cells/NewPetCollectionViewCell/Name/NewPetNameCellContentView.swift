//
//  NewPetNameCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

final class NewPetNameCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Nombre del animal / Título"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let txtField = UITextField(frame: .zero)
        txtField.textColor = .label
        txtField.tintColor = .orange
        txtField.textAlignment = .left
        txtField.font = .systemFont(ofSize: 16, weight: .regular)
        txtField.backgroundColor = .clear
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return txtField
    }()
    
    // MARK: - Properties
    private var currentConfiguration: NewPetNameListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetNameListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetNameListCellConfiguration) {
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
        checkMaxLength(textField)
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetNameListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        nameTextField.text = item.name ?? ""
    }
    
    let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(nameTextField)
        
        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingBottom: 10
        )
        containerView.setHeight(50)
        
        titleLabel.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor
        )
        
        nameTextField.anchor(
            top: titleLabel.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: 10
        )
    }
    
    
    private func checkMaxLength(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if (text.count) > 15 {
            textField.deleteBackward()
        }
        currentConfiguration.viewModel?.delegate?.textFieldDidChange(text: textField.text ?? "")
    }


}

extension NewPetNameCellContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
}
