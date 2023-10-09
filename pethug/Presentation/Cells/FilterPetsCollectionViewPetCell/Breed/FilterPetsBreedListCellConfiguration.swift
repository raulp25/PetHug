//
//  FilterPetsBreedListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsBreedDelegate: AnyObject {
    func didTapBreedSelector()
}

struct FilterPetsBreed: Hashable {
    static func == (lhs: FilterPetsBreed, rhs: FilterPetsBreed) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.currentBreed == rhs.currentBreed &&
            lhs.petType == rhs.petType
        )
    }
    var id = UUID().uuidString
    var currentBreed: String?
    var petType: Pet.PetType?
    weak var delegate: FilterPetsBreedDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(currentBreed: String? = nil) {
        self.currentBreed = currentBreed
    }
}

struct FilterPetsBreedListCellConfiguration: ContentConfigurable {
    var viewModel: FilterPetsBreed?

    func makeContentView() -> UIView & UIContentView {
        return FilterPetsBreedCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> FilterPetsBreedListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self
        
        if state.isSwiped {
        }

        return updateConfiguration
    }
}


