//
//  FilterPetsAddressCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

final class FilterPetsAddressCellContentView: UIView, UIContentView {
    
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.text = "Ubicación"
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Estado"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
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
        label.text = "Todo México"
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
    
    //MARK: - Private properties
    private enum CurrentChecked: Int {
        case all = 1
        case state = 2
    }
    private let addressKey = FilterKeys.filterAddress.rawValue
    private let allCountry = "AllCountry"
    // MARK: - Properties
    private var currentConfiguration: FilterPetsAddressListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? FilterPetsAddressListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsAddressListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()

        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func apply(configuration: FilterPetsAddressListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        
        updateButtonUIForAddressState(item.address?.rawValue)
        
    }
    
    private func setup() {
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        
        addSubview(headerLabel)
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(addressLabel)
        containerView.addSubview(chevronImageView)
        addSubview(hStackAll)
        
        headerLabel.centerX(inView: self, topAnchor: topAnchor)
        
        titleLabel.anchor(
            top: headerLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 30
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
        chevronImageView.setDimensions(
            height: 20,
            width: 20
        )
        
        addressLabel.centerY(
            inView: containerView
        )
        addressLabel.anchor(
            left: containerView.leftAnchor,
            right: chevronImageView.leftAnchor,
            paddingLeft: 10
        )
        
        hStackAll.anchor(
            top: containerView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 10,
            paddingLeft: 10,
            paddingBottom: 20
        )
        
        hStackAll.setHeight(37.5)
    }
    
    // MARK: - Private actions
    @objc private func didTapCheckMark(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        sender.tintColor = .systemOrange
        currentConfiguration.viewModel?.delegate?.didTapAllCountry()
    }
    
    @objc func didTapCell() {
        currentConfiguration.viewModel?.delegate?.didTapAddressSelector()
    }
    
    //MARK: - Private methods
    private func updateButtonUIForAddressState(_ address: String?) {
        
        if address == allCountry {
            allCheckMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            allCheckMarkButton.tintColor = .systemOrange
        } else {
            addressLabel.text = address ??  "Donte te ubicas"
            allCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
            allCheckMarkButton.tintColor = .black
        }
        
    }
}









