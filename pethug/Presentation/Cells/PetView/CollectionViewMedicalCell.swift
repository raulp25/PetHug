//
//  CollectionViewMedicalCell.swift
//  pethug
//
//  Created by Raul Pena on 08/10/23.
//

import UIKit

class PetViewMedicalCollectionViewCell: UICollectionViewCell {
    
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
    
    private var internalDeworming: TextCheckbox? = nil
    private var externalDeworming: TextCheckbox? = nil
    private var microchip: TextCheckbox? = nil
    private var sterilized: TextCheckbox? = nil
    private var vaccinated: TextCheckbox? = nil
    
    //MARK: - LifeCycle
    func configure(with medicalInfo: MedicalInfo) {
        configureCellUI(with: medicalInfo)
        configureConstraints()
    }
    
    override func prepareForReuse() {
        clearComponents()
    }
    
    private func configureCellUI(with medicalInfo: MedicalInfo) {
        internalDeworming = TextCheckbox(
                                titleText: "Desparasitación Interna",
                                isChecked: medicalInfo.internalDeworming
                            )
        externalDeworming = TextCheckbox(
                                titleText: "Desparasitación Externa",
                                isChecked: medicalInfo.externalDeworming
                            )
        microchip = TextCheckbox(
                        titleText: "Microchip",
                        isChecked: medicalInfo.microchip
                    )
        sterilized = TextCheckbox(
                        titleText: "Esterilizado",
                        isChecked: medicalInfo.sterilized
                    )
        vaccinated = TextCheckbox(
                        titleText: "Vacunas",
                        isChecked: medicalInfo.vaccinated
                    )
        
        let textCheckBoxes = [
            internalDeworming,
            externalDeworming,
            microchip,
            sterilized,
            vaccinated
        ]
        
        for textCheckbox in textCheckBoxes {
            if let textCheckbox = textCheckbox {
                vStack.addArrangedSubview(textCheckbox)
            }
            
        }
    }
    
    private func configureConstraints() {
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
            paddingTop: 10
        )
    }
    
    private func clearComponents() {
        internalDeworming?.removeFromSuperview()
        externalDeworming?.removeFromSuperview()
        microchip?.removeFromSuperview()
        sterilized?.removeFromSuperview()
        vaccinated?.removeFromSuperview()
        
        internalDeworming = nil
        externalDeworming = nil
        microchip = nil
        sterilized = nil
        vaccinated = nil
    }
    
}
