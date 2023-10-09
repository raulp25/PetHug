//
//  FilterPetTypeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsTypeDelegate: AnyObject {
    func typeDidChange(type: Pet.PetType)
}

struct FilterPetsType: Hashable {
    static func == (lhs: FilterPetsType, rhs: FilterPetsType) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.type == rhs.type
        )
    }
    var id = UUID().uuidString
    var type: Pet.PetType? = nil
    weak var delegate: FilterPetsTypeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(type: Pet.PetType? = nil) {
        self.type = type
    }
}

struct FilterPetsTypeListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsType?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsTypeCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsTypeListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}


