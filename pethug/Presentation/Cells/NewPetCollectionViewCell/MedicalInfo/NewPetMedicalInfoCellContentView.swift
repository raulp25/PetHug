//
//  File.swift
//  pethug
//
//  Created by Raul Pena on 18/10/23.
//

import UIKit

final class NewPetMedicalInfoCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Se entrega"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private lazy var internalDeworming: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Desparasitación Interna",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    
    private lazy var externalDeworming: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Desparasitación Externa",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    
    private lazy var microchip: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Microchip",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    
    private lazy var sterilized: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Esterilizado",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    
    private lazy var vaccinated: TextCheckbox = {
        let tb = TextCheckbox(titleText: "Vacunas",
                              isChecked: false,
                              font: UIFont.systemFont(ofSize: 12, weight: .regular),
                              isClickable: true,
                              delegate: self)
        return tb
    }()
    
    
    
    
    // MARK: - Properties
    private var currentConfiguration: NewPetMedicalInfoListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetMedicalInfoListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetMedicalInfoListCellConfiguration) {
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
    private func apply(configuration: NewPetMedicalInfoListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let item = currentConfiguration.viewModel else { return }
        configureCellUI(with: item.medicalInfo)
        
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(vStack)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor
        )
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 20
        )
        
        vStack.setHeight(175)
        
        let textCheckBoxes = [
            internalDeworming,
            externalDeworming,
            microchip,
            sterilized,
            vaccinated
        ]
        
        for textCheckbox in textCheckBoxes {
            vStack.addArrangedSubview(textCheckbox)
        }
    }
    
    
    private func configureCellUI(with medicalInfo: MedicalInfo) {
        internalDeworming.isChecked = medicalInfo.internalDeworming
        externalDeworming.isChecked = medicalInfo.externalDeworming
        microchip.isChecked         = medicalInfo.microchip
        sterilized.isChecked        = medicalInfo.sterilized
        vaccinated.isChecked        = medicalInfo.vaccinated
        
    }
    
    
}

extension NewPetMedicalInfoCellContentView: TextCheckBoxDelegate {
    func didTapCheckBox() {
        
        let medicalInfo = MedicalInfo(internalDeworming: internalDeworming.isChecked,
                                      externalDeworming: externalDeworming.isChecked,
                                      microchip: microchip.isChecked,
                                      sterilized: sterilized.isChecked,
                                      vaccinated: vaccinated.isChecked)
        print(":medicalInfo en delegate => \(medicalInfo)")
        currentConfiguration.viewModel?.delegate?.medicalInfoChanged(to: medicalInfo)
    }
}








