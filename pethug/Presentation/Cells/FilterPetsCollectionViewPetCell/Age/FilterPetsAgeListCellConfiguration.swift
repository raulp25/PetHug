//
//  FilterPetsAgeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsAgeDelegate: AnyObject {
    func ageChanged(age: Int?)
}

struct FilterPetsAge: Hashable {
    static func == (lhs: FilterPetsAge, rhs: FilterPetsAge) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.age == rhs.age
        )
    }
    var id = UUID().uuidString
    var age: Int?
    weak var delegate: FilterPetsAgeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(age: Int? = nil) {
        self.age = age
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

