//
//  FilterPetsAddressListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsAddressDelegate: AnyObject {
//    func textViewdDidChange(text: String)
    func didTapAddressSelector()
    func didTapAllCountry()
}

struct FilterPetsAddress: Hashable {
    static func == (lhs: FilterPetsAddress, rhs: FilterPetsAddress) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.address == rhs.address
        )
    }
    var id = UUID().uuidString
    var address: Pet.FilterState?
    weak var delegate: FilterPetsAddressDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(address: Pet.FilterState?) {
        self.address = address
    }
}

struct FilterPetsAddressListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsAddress?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsAddressCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsAddressListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

