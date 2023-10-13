//
//  FilterSearchAddressListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 12/10/23.
//

import UIKit

protocol FilterSearchAddressDelegate: AnyObject {
//    func textViewdDidChange(text: String)
    func didTapCell(state: FilterState)
}


struct FilterSearchAddressListCellConfiguration: ContentConfigurable {
    var viewModel: FilterSearchAddress?

    func makeContentView() -> UIView & UIContentView {
        return FilterSearchAddressCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterSearchAddressListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

