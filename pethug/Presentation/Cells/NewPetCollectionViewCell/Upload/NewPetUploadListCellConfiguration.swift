//
//  NewPetUploadListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit
import Combine
protocol NewPetUploadDelegate: AnyObject {
    func didTapUpload()
}

class NewPetUpload: Hashable {
    static func == (lhs: NewPetUpload, rhs: NewPetUpload) -> Bool {
        //Since we are using a publisher we dont need to check isValid for equality
        (
            lhs.id == rhs.id
        )
    }
    var id = UUID().uuidString
    var isFormValid: CurrentValueSubject<Bool, Never>?
    var state: PassthroughSubject<NewPetViewModel.LoadingState, Never>?
    var buttonText: String = "Subir"
    weak var delegate: NewPetUploadDelegate?
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

