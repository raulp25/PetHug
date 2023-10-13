//
//  FilterPetsSendCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit
import Combine

final class FilterPetsSendCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private lazy var cleanFieldsBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .clear
        btn.setTitle("Limpiar campos", for: .normal)
        btn.tintColor = .black.withAlphaComponent(0.8)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
        btn.addTarget(self, action: #selector(upload), for: .touchUpInside)
        return btn
    }()
    
    private lazy var uploadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Filtrar", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 255, green: 176, blue: 42)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(upload), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Properties
    private var currentConfiguration: FilterPetsSendListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? FilterPetsSendListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsSendListCellConfiguration) {
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
    @objc private func upload() {
        print(":clicked upload button => ")
//        currentConfiguration.viewModel?.delegate?.didTapSend()
    }
    
    
    // MARK: - Functions
    private func apply(configuration: FilterPetsSendListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        
        item.isFormValid?
            .handleThreadsOperator()
            .sink(receiveValue: { [weak self] isValid in
                self?.uploadBtn.backgroundColor = isValid ?
                customRGBColor(red: 255, green: 176, blue: 42) :
                customRGBColor(red: 250, green: 219, blue: 165, alpha: 1)
                
                self?.uploadBtn.isEnabled = isValid
            }).store(in: &cancellables)
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        addSubview(containerView)
        containerView.addSubview(cleanFieldsBtn)
        containerView.addSubview(uploadBtn)

        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingBottom: 10
        )
        containerView.setHeight(35)
        
        cleanFieldsBtn.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor
        )
        
        uploadBtn.anchor(
            top: containerView.topAnchor,
            left: cleanFieldsBtn.rightAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingLeft: 20
        )
        
        cleanFieldsBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uploadBtn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
    }


}



