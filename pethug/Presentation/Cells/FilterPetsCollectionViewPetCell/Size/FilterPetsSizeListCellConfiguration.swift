//
//  FilterPetsSizeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsSizeDelegate: AnyObject {
    func sizeDidChange(size: Pet.Size?)
}

struct FilterPetsSize: Hashable {
    static func == (lhs: FilterPetsSize, rhs: FilterPetsSize) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.size == rhs.size
        )
    }
    var id = UUID().uuidString
    var size: Pet.Size? = nil
    weak var delegate: FilterPetsSizeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(size: Pet.Size? = nil) {
        self.size = size
    }
}

struct FilterPetsSizeListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsSize?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsSizeCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsSizeListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}



