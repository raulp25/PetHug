//
//  NewPetBreedListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

protocol NewPetBreedDelegate: AnyObject {
//    func textViewdDidChange(text: String)
    func didTapBreedSelector()
}

class NewPetBreed: Hashable {
    static func == (lhs: NewPetBreed, rhs: NewPetBreed) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var breed: String?
    var breedsFor: Pet.PetType?
    var isEnabled: Bool = false
    weak var delegate: NewPetBreedDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(breed)
       }
    init(breed: String) {
        self.breed = breed
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

