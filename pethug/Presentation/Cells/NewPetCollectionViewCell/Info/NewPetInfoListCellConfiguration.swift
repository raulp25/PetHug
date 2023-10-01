//
//  NewPetInfoListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit

protocol NewPetInfoDelegate: AnyObject {
    func textViewdDidChange(text: String)
}

class NewPetInfo: Hashable {
    static func == (lhs: NewPetInfo, rhs: NewPetInfo) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var info: String?
    weak var delegate: NewPetInfoDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(info)
       }
    init(info: String? = nil) {
        self.info = info
    }
}

struct NewPetInfoListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetInfo?

    func makeContentView() -> UIView & UIContentView {
        return NewPetInfoCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetInfoListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}
