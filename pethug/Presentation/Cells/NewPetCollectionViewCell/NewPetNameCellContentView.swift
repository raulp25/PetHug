//
//  NewPetNameCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

final class NewPetNameCellContentView: UIView, UIContentView {
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
//        setup()

        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetNameListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
//
//        guard let item = currentConfiguration.viewModel else { return }
//        nameLabel.text = item.name
//        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        nameLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
//
//        imageView.configure(with: item.profileImageUrlString)
    }

}
