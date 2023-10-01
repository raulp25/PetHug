//
//  NewPetAddressListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol NewPetAddressDelegate: AnyObject {
//    func textViewdDidChange(text: String)
    func didTapAddressSelector()
}

struct NewPetAddress: Hashable {
    static func == (lhs: NewPetAddress, rhs: NewPetAddress) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var address: Pet.State?
    weak var delegate: NewPetAddressDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(address: Pet.State?) {
        self.address = address
    }
}

struct NewPetAddressListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetAddress?

    func makeContentView() -> UIView & UIContentView {
        return NewPetAddressCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetAddressListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}
