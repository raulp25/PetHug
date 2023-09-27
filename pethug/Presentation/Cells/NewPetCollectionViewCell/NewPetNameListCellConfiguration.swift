//
//  NewPetListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

struct NewPetNameListCellConfiguration: ContentConfigurable {
    var viewModel: String?

    func makeContentView() -> UIView & UIContentView {
        return NewPetNameCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetNameListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}
