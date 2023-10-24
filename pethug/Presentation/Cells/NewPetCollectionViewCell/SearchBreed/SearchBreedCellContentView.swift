//
//  SearchBreedCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

final class SearchBreedCellContentView: UIView, UIContentView {
    
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        uv.isUserInteractionEnabled = true
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
        iv.image = UIImage(systemName: "tree.circle.fill")
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.isUserInteractionEnabled = true
        return iv
    }()

    // MARK: - Properties
    private var currentConfiguration: SearchBreedListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? SearchBreedListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: SearchBreedListCellConfiguration) {
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
        guard let viewModel = currentConfiguration.viewModel else { return }
        currentConfiguration.viewModel?.delegate?.didTapCell(breed:  viewModel.breed)
    }
    
    // MARK: - Functions
    private func apply(configuration: SearchBreedListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
        
        guard let item = currentConfiguration.viewModel else { return }
        breedLabel.text = item.breed
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(containerView)
        containerView.addSubview(breedLabel)
        containerView.addSubview(chevronImageView)
        
        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 10,
            paddingBottom: 10
        )
        containerView.setHeight(20)
        containerView.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        chevronImageView.centerY(
            inView: containerView
        )
        chevronImageView.anchor(
            right: containerView.rightAnchor,
            paddingRight: 10
        )
        chevronImageView.setDimensions(height: 20, width: 20)
        
        breedLabel.centerY(
            inView: containerView
        )
        breedLabel.anchor(
            left: containerView.leftAnchor,
            right: chevronImageView.leftAnchor,
            paddingLeft: 10
        )
    }
    
    
    
}







