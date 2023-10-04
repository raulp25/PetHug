//
//  NewPetActivityListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit

protocol NewPetActivityDelegate: AnyObject {
    func activityLevelChanged(to level: Int?)
}

struct NewPetActivity: Hashable {
    static func == (lhs: NewPetActivity, rhs: NewPetActivity) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.activityLevel == rhs.activityLevel
        )
    }
    var id = UUID().uuidString
    var activityLevel: Int?
    weak var delegate: NewPetActivityDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(activityLevel: Int? = nil) {
        self.activityLevel = activityLevel
    }
}

struct NewPetActivityListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetActivity?

    func makeContentView() -> UIView & UIContentView {
        return NewPetActivityCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetActivityListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

