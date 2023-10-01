//
//  NewPetSizeListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import Foundation

import UIKit

protocol NewPetSizeDelegate: AnyObject {
    func sizeDidChange(type: String)
}

class NewPetSize: Hashable {
    static func == (lhs: NewPetSize, rhs: NewPetSize) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var size: String? = nil
    weak var delegate: NewPetSizeDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(size: String? = nil) {
        self.size = size
    }
}

struct NewPetSizeListCellConfiguration: ContentConfigurable {
    var viewModel: FormDataManager?

    func makeContentView() -> UIView & UIContentView {
        return NewPetSizeCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetSizeListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}


