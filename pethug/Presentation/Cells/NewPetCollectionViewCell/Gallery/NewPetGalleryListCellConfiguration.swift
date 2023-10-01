//
//  NewPetGalleryListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol NewPetGalleryDelegate: AnyObject {
    func galleryDidChange(images: [UIImage])
}

struct NewPetGallery: Hashable {
    static func == (lhs: NewPetGallery, rhs: NewPetGallery) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.images == rhs.images
        )
    }
    var id = UUID().uuidString
    var images: [String] = []
    weak var delegate: NewPetGalleryDelegate?
    weak var nagivagtion: NewPetContentViewController?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(images: [String] = []) {
        self.images = images
    }
}

struct NewPetGalleryListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetGallery?

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

