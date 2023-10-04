//
//  NewPetAffectionListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit

protocol NewPetAffectionDelegate: AnyObject {
    func affectionLevelChanged(to level: Int?)
}

struct NewPetAffection: Hashable {
    static func == (lhs: NewPetAffection, rhs: NewPetAffection) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.affectionLevel == rhs.affectionLevel
        )
    }
    var id = UUID().uuidString
    var affectionLevel: Int?
    weak var delegate: NewPetAffectionDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(affectionLevel: Int? = nil) {
        self.affectionLevel = affectionLevel
    }
}

struct NewPetAffectionListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetAffection?

    func makeContentView() -> UIView & UIContentView {
        return NewPetAffectionCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetAffectionListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}



