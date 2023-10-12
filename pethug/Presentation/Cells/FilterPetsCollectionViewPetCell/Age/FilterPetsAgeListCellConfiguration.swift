//
//  FilterPetsAgeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsAgeDelegate: AnyObject {
    func ageChanged(ageRange: (Int, Int)?)
}

struct FilterPetsAge: Hashable {
    static func == (lhs: FilterPetsAge, rhs: FilterPetsAge) -> Bool {
        (
            lhs.id == rhs.id 
        )
    }
    var id = UUID().uuidString
    var ageRange: (Int, Int)?
    weak var delegate: FilterPetsAgeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(ageRange: (Int, Int)? = nil) {
        self.ageRange = ageRange
    }
}

struct FilterPetsAgeListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsAge?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsAgeCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsAgeListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

