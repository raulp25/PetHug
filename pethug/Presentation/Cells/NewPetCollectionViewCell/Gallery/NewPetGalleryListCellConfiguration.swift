//
//  NewPetGalleryListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol NewPetGalleryDelegate: AnyObject {
    func imagesDidChange(text: String)
}

class NewPetGallery: Hashable {
    static func == (lhs: NewPetGallery, rhs: NewPetGallery) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var images: [Data] = []
    weak var delegate: NewPetNameDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(images: [Data] = []) {
        self.images = images
    }
}

struct NewPetGalleryListCellConfiguration: ContentConfigurable {
    var viewModel: FormDataManager?

    func makeContentView() -> UIView & UIContentView {
        return NewPetGalleryCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetGalleryListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

