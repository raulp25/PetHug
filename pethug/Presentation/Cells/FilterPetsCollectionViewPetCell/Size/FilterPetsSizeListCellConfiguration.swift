//
//  FilterPetsSizeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsSizeDelegate: AnyObject {
    func sizeDidChange(size: FilterSize)
}

struct FilterPetsSize: Hashable {
    static func == (lhs: FilterPetsSize, rhs: FilterPetsSize) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.size == rhs.size
        )
    }
    var id = UUID().uuidString
    var size: FilterSize
    weak var delegate: FilterPetsSizeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(size: FilterSize = .all) {
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



