//
//  SearchAddressListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol SearchAddressDelegate: AnyObject {
    func didTapCell(state: Pet.State)
}


struct SearchAddressListCellConfiguration: ContentConfigurable {
    var viewModel: SearchAddress?

    func makeContentView() -> UIView & UIContentView {
        return SearchAddressCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> SearchAddressListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}
