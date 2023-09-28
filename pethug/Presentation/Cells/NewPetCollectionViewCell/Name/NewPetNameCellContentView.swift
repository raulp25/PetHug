//
//  NewPetNameCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

final class NewPetNameCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [containerView])
        stack.axis = .vertical
//        stack.distribution = .
        stack.alignment = .fill
//        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Nombre del animal / Título"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let txtField = UITextField(frame: .zero)
//        txtField.placeholder = "Search ANAL5"
        txtField.textColor = .label
        txtField.tintColor = .orange
        txtField.textAlignment = .left
        txtField.font = .systemFont(ofSize: 16, weight: .regular)
        txtField.backgroundColor = .clear
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
        currentConfiguration.viewModel?.delegate?.textFieldDidChange(text: textField.text ?? "")
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetNameListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
//
        guard let item = currentConfiguration.viewModel else { return }
//        nameLabel.text = item.name
//        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        nameLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
//
//        imageView.configure(with: item.profileImageUrlString)
    }
    
    
    let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private func setup() {
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
//        addSubview(vStack)
        addSubview(containerView)
//        vStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 20)
//        let bottomConstraint = vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
//        bottomConstraint.priority = .sceneSizeStayPut
//        bottomConstraint.isActive = true
        
//        vStack.layer.borderColor = UIColor.green.cgColor
//        vStack.layer.borderWidth = 2
//        titleLabel.setHeight(18)
//        nameTextField.setHeight(20)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10)
        containerView.addSubview(titleLabel)
        containerView.addSubview(nameTextField)
        containerView.setHeight(50)
//            containerView.layer.borderColor = UIColor.green.cgColor
//            containerView.layer.borderWidth = 2
        
        titleLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
//        titleLabel.setHeight(18)
        
        nameTextField.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 10)
//        nameTextField.setHeight(20)
    }


}
