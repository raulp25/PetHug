//
//  NewPetGenderListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit

protocol NewPetGenderDelegate: AnyObject {
    func genderDidChange(type: Pet.Gender?)
}

class NewPetGender: Hashable {
    static func == (lhs: NewPetGender, rhs: NewPetGender) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var gender: Pet.Gender? = nil
    weak var delegate: NewPetGenderDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(gender: Pet.Gender? = nil) {
        self.gender = gender
    }
}

struct NewPetGenderListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetGender?

    func makeContentView() -> UIView & UIContentView {
        return NewPetGenderCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetGenderListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}


