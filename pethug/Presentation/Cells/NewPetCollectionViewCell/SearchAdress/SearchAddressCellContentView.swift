//
//  SearchAddressCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

final class SearchAddressCellContentView: UIView, UIContentView {
    
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        label.numberOfLines = 1
        return label
    }()
    
    private let chevronImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "tree.circle.fill")
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.isUserInteractionEnabled = true
        return iv
    }()

    
    // MARK: - Properties
    private var currentConfiguration: SearchAddressListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? SearchAddressListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: SearchAddressListCellConfiguration) {
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
    private func apply(configuration: SearchAddressListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
//
        guard let item = currentConfiguration.viewModel else { return }
//        nameLabel.text = item.name
        addressLabel.text = item.address
//        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        nameLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
//
//        imageView.configure(with: item.profileImageUrlString)
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        addSubview(containerView)
        containerView.backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        containerView.addSubview(addressLabel)
        containerView.addSubview(chevronImageView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingBottom: 10)
        containerView.setHeight(20)
        
//        containerView.layer.cornerRadius = 20
        chevronImageView.centerY(inView: containerView)
        chevronImageView.anchor(right: containerView.rightAnchor, paddingRight: 10)
        chevronImageView.setDimensions(height: 20, width: 20)
        addressLabel.centerY(inView: containerView)
        addressLabel.anchor(left: containerView.leftAnchor, right: chevronImageView.leftAnchor, paddingLeft: 10)
    }
    
    
    
}


