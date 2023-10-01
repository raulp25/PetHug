//
//  NewPetTypeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol NewPetTypeDelegate: AnyObject {
    func typeDidChange(type: Pet.PetType)
}

class NewPetType: Hashable {
    static func == (lhs: NewPetType, rhs: NewPetType) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var type: Pet.PetType? = nil
    weak var delegate: NewPetTypeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(type: Pet.PetType? = nil) {
        self.type = type
    }
}

struct NewPetTypeListCellConfiguration: ContentConfigurable {
    var viewModel: FormDataManager?

    func makeContentView() -> UIView & UIContentView {
        return NewPetTypeCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetTypeListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

