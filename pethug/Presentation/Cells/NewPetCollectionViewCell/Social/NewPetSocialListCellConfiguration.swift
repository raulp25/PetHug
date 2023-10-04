//
//  NewPetSocialListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit

protocol NewPetSocialDelegate: AnyObject {
    func socialLevelChanged(to level: Int?)
}

struct NewPetSocial: Hashable {
    static func == (lhs: NewPetSocial, rhs: NewPetSocial) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.socialLevel == rhs.socialLevel
        )
    }
    var id = UUID().uuidString
    var socialLevel: Int?
    weak var delegate: NewPetSocialDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(socialLevel: Int? = nil) {
        self.socialLevel = socialLevel
    }
}

struct NewPetSocialListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetSocial?

    func makeContentView() -> UIView & UIContentView {
        return NewPetSocialCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetSocialListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}


