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
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Nombre del animal / Título"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var uploadBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Subir"))
        btn.backgroundColor = customRGBColor(red: 255, green: 176, blue: 42)
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
        currentConfiguration.viewModel?.delegate?.didTapSend()
    }
    
    
    // MARK: - Functions
    private func apply(configuration: FilterPetsSendListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        uploadBtn.setTitle(item.buttonText, for: .normal)
        uploadBtn.backgroundColor = customRGBColor(red: 255, green: 176, blue: 42)
    }
    
    

    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        addSubview(containerView)
        containerView.addSubview(uploadBtn)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10)
        containerView.setHeight(45)
        
        uploadBtn.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
    }


}



