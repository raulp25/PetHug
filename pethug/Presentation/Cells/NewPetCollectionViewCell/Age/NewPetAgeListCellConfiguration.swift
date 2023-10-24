//
//  NewPetAgeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//
import UIKit

protocol NewPetAgeDelegate: AnyObject {
    func ageChanged(age: Int?)
}

struct NewPetAge: Hashable {
    static func == (lhs: NewPetAge, rhs: NewPetAge) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.age == rhs.age
        )
    }
    var id = UUID().uuidString
    var age: Int?
    weak var delegate: NewPetAgeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
    }
    init(age: Int? = nil) {
        self.age = age
    }
}

struct NewPetAgeListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetAge?

    func makeContentView() -> UIView & UIContentView {
        return NewPetAgeCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetAgeListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

