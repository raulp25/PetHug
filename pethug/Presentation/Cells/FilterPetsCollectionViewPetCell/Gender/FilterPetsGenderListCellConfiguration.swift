//
//  FilterPetsGenderListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsGenderDelegate: AnyObject {
    func genderDidChange(type: Pet.Gender?)
}

struct FilterPetsGender: Hashable {
    static func == (lhs: FilterPetsGender, rhs: FilterPetsGender) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.gender == rhs.gender
        )
    }
    var id = UUID().uuidString
    var gender: Pet.Gender? = nil
    weak var delegate: FilterPetsGenderDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(gender: Pet.Gender? = nil) {
        self.gender = gender
    }
}

struct FilterPetsGenderListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsGender?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsGenderCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsGenderListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}



