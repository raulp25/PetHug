//
//  NewPetBreedCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

final class NewPetBreedCellContentView: UIView, UIContentView {
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Raza"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        
        //isUserInteractionEnabled is handled by the apply() fn
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private let breedLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        label.numberOfLines = 1
        return label
    }()
    
    private let chevronImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.down")
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.isUserInteractionEnabled = true
        return iv
    }()

    
    // MARK: - Properties
    private var currentConfiguration: NewPetBreedListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetBreedListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetBreedListCellConfiguration) {
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
//        currentConfiguration.viewModel?.delegate?.textViewdDidChange(text: textField.text ?? "")
    }
    
    @objc func didTapCell() {
        print(": =>didtap cell objc ")
        currentConfiguration.viewModel?.delegate?.didTapBreedSelector()
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetBreedListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
//
        guard let item = currentConfiguration.viewModel else { return }
        containerView.isUserInteractionEnabled = item.isEnabled
//        breedLabel.text = item.breed != nil ? "Eliga el tipo de animal para continuar" : "Dachshund"
          breedLabel.text = item.breedsFor == nil ? "Eliga un tipo de animal para continuar" : "Dachshund"
//        nameLabel.text = item.name
//        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        nameLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
//
//        imageView.configure(with: item.profileImageUrlString)
    }
    
    

    
    private func setup() {
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        addSubview(titleLabel)
        addSubview(containerView)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        containerView.addSubview(breedLabel)
        containerView.addSubview(chevronImageView)
        containerView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 30)
        containerView.setHeight(40)
        
        containerView.layer.cornerRadius = 10
        chevronImageView.centerY(inView: containerView)
        chevronImageView.anchor(right: containerView.rightAnchor, paddingRight: 5)
        
        breedLabel.centerY(inView: containerView)
        breedLabel.anchor(left: containerView.leftAnchor, right: chevronImageView.leftAnchor, paddingLeft: 5)
    }
    
    
    
}

extension NewPetBreedCellContentView: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        nameTextField.resignFirstResponder()
//    }
    
}


