//
//  FilterPetsSendListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit
import Combine
protocol FilterPetsSendDelegate: AnyObject {
    func didTapSend()
}

class FilterPetsSend: Hashable {
    static func == (lhs: FilterPetsSend, rhs: FilterPetsSend) -> Bool {
        //Since we are using a publisher we dont need to check isValid for equality
        (
            lhs.id == rhs.id
        )
    }
    var id = UUID().uuidString
    var buttonText: String = "Filtrar"
    weak var delegate: FilterPetsSendDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init() {
    }
}

struct FilterPetsSendListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsSend?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsSendCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsSendListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}


