//
//  NewPetBreedListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol NewPetBreedDelegate: AnyObject {
    func didTapBreedSelector()
}

struct NewPetBreed: Hashable {
    static func == (lhs: NewPetBreed, rhs: NewPetBreed) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.currentBreed == rhs.currentBreed
        )
    }
    var id = UUID().uuidString
    var currentBreed: String?
    var petType: Pet.PetType?
    weak var delegate: NewPetBreedDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(currentBreed: String? = nil) {
        self.currentBreed = currentBreed
    }
}

struct NewPetBreedListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetBreed?

    func makeContentView() -> UIView & UIContentView {
        return NewPetBreedCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetBreedListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self
        
        if state.isSwiped {
        }

        return updateConfiguration
    }
}

