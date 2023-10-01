//
//  SearchBreedListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol SearchBreedDelegate: AnyObject {
//    func textViewdDidChange(text: String)
    func didTapBreedSelector()
}

class SearchBreed: Hashable {
    static func == (lhs: SearchBreed, rhs: SearchBreed) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var breed: String
    weak var delegate: SearchBreedDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(breed)
       }
    init(breed: String) {
        self.breed = breed
    }
}

struct SearchBreedListCellConfiguration: ContentConfigurable {
    var viewModel: SearchBreed?

    func makeContentView() -> UIView & UIContentView {
        return SearchBreedCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> SearchBreedListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

