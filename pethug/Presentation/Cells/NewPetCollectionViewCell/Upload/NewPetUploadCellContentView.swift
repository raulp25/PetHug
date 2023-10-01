//
//  NewPetUploadCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit

final class NewPetUploadCellContentView: UIView, UIContentView {
    //MARK: - Private components
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
    private var currentConfiguration: NewPetUploadListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetUploadListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetUploadListCellConfiguration) {
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
    }
    
    
    // MARK: - Functions
    private func apply(configuration: NewPetUploadListCellConfiguration) {
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
        addSubview(containerView)
        containerView.addSubview(uploadBtn)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10)
        containerView.setHeight(45)
        
        uploadBtn.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
    }


}


