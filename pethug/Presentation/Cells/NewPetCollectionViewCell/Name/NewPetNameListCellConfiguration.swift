//
//  NewPetListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol NewPetNameDelegate: AnyObject {
    func textFieldDidChange(text: String)
}

struct NewPetName: Hashable {
    static func == (lhs: NewPetName, rhs: NewPetName) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var name: String?
    weak var delegate: NewPetNameDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(name: String? = nil) {
        self.name = name
    }
}

struct NewPetNameListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetName?

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
