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
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
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
    
    private lazy var hStackUnknownBreed: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [unknownBreedLabel, unknownBreedCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let unknownBreedLabel: UILabel = {
        let label = UILabel()
        label.text = "Mestizo"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var unknownBreedCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()

    
    private let unknownBreed = "Mestizo"
    
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
    @objc func didTapCell() {
        print(": =>didtap cell objc ")
        currentConfiguration.viewModel?.delegate?.didTapBreedSelector()
    }
    
    @objc private func didTapCheckMark(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        sender.tintColor = .systemOrange
        currentConfiguration.viewModel?.delegate?.didTapUnkownedBreed()
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetBreedListCellConfiguration) {
        print("currentConfiguration != configuration 552: => \(currentConfiguration != configuration)")
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        containerView.isUserInteractionEnabled = item.petType != nil ? true : false
        
        if item.petType == nil {
            breedLabel.text =  "Eliga un tipo de animal para continuar"
            unknownBreedCheckMarkButton.isUserInteractionEnabled = false
        } else {
            updateButtonUIForBrredState(item.currentBreed)
        }
    }
    

    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        
        addSubview(containerView)
        containerView.addSubview(breedLabel)
        containerView.addSubview(chevronImageView)
        
        addSubview(hStackUnknownBreed)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        containerView.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 30
        )
        containerView.setHeight(40)
        containerView.layer.cornerRadius = 10
        
        chevronImageView.centerY(
            inView: containerView
        )
        chevronImageView.anchor(
            right: containerView.rightAnchor,
            paddingRight: 5
        )
        chevronImageView.setWidth(20)
        
        breedLabel.centerY(
            inView: containerView
        )
        breedLabel.anchor(
            left: containerView.leftAnchor,
            right: chevronImageView.leftAnchor,
            paddingLeft: 10
        )
        
        hStackUnknownBreed.anchor(
            top: containerView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 10,
            paddingLeft: 10,
            paddingBottom: 20
        )
        hStackUnknownBreed.setHeight(37.5)
    }
    
    //MARK: - Private methods
    private func updateButtonUIForBrredState(_ breed: String?) {
        unknownBreedCheckMarkButton.isUserInteractionEnabled = true
        
        if breed == unknownBreed {
            breedLabel.text = ""
            unknownBreedCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            unknownBreedCheckMarkButton.tintColor = .systemOrange
        } else {
            breedLabel.text = breed ??  "Elige una raza"
            unknownBreedCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
            unknownBreedCheckMarkButton.tintColor = .black
        }
        
    }
    
}


