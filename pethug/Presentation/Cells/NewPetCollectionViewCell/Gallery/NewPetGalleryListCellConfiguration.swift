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
            lhs.imagesToEdit == rhs.imagesToEdit
        )
    }
    var id = UUID().uuidString
    var imagesToEdit: [String] = []
    var imageService: ImageService?
    weak var delegate: NewPetGalleryDelegate?
    weak var navigation: NewPetContentViewController?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
    }
    init(imagesToEdit: [String] = [], imageService: ImageService? = nil) {
        self.imagesToEdit = imagesToEdit
        self.imageService = imageService
    }
    
    // Downloads cell images
    func getImagetImagesSequentially(stringUrlArray: [String], completion: @escaping([UIImage]) -> Void) {
        if !imagesToEdit.isEmpty, let imageService = imageService {
            var images = [UIImage]()
            
            func downloadNextImage(index: Int) {
                   if index >= stringUrlArray.count {
                       completion(images)
                   } else {
                       let imageUrl = stringUrlArray[index]
                       imageService.downloadImage(url: imageUrl) { imageData in
                           if let imageData = imageData, let image = UIImage(data: imageData) {
                               images.append(image)
                           }
                           downloadNextImage(index: index + 1)
                       }
                   }
               }

               downloadNextImage(index: 0)
        }
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

