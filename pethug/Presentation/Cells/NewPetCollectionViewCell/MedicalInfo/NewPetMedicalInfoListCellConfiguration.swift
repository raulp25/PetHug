//
//  NewPetMedicalInfoListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 18/10/23.
//

import UIKit

protocol NewPetMedicalInfoDelegate: AnyObject {
    func medicalInfoChanged(to newMedicalInfo: MedicalInfo)
}

struct NewPetMedicalInfo: Hashable {
    static func == (lhs: NewPetMedicalInfo, rhs: NewPetMedicalInfo) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.medicalInfo.externalDeworming == rhs.medicalInfo.externalDeworming &&
            lhs.medicalInfo.internalDeworming == rhs.medicalInfo.internalDeworming &&
            lhs.medicalInfo.microchip == rhs.medicalInfo.microchip &&
            lhs.medicalInfo.sterilized == rhs.medicalInfo.sterilized &&
            lhs.medicalInfo.vaccinated == rhs.medicalInfo.vaccinated
        )
    }
    var id = UUID().uuidString
    var medicalInfo: MedicalInfo = MedicalInfo(internalDeworming: false, externalDeworming: false, microchip: false, sterilized: false, vaccinated: false)
    weak var delegate: NewPetMedicalInfoDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(medicalInfo: MedicalInfo) {
        self.medicalInfo = medicalInfo
    }
}

struct NewPetMedicalInfoListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetMedicalInfo?

    func makeContentView() -> UIView & UIContentView {
        return NewPetMedicalInfoCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetMedicalInfoListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}




