//
//  NewPetUploadListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit
import Combine
protocol NewPetUploadDelegate: AnyObject {
    func uploaddDidChange(text: String)
}

class NewPetUpload: Hashable {
    static func == (lhs: NewPetUpload, rhs: NewPetUpload) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var isValid: CurrentValueSubject<Bool, Never>?
//    weak var delegate: NewPetNameDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init() {
    }
}

struct NewPetUploadListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetUpload?

    func makeContentView() -> UIView & UIContentView {
        return NewPetUploadCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetUploadListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}

