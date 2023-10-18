//
//  NewPetSocialInfoListCellConfiguration.swift
//  pethug
//
//  Created by Raul Pena on 18/10/23.
//

import UIKit

protocol NewPetSocialInfoDelegate: AnyObject {
    func socialInfoChanged(to newSocialInfo: SocialInfo)
}

struct NewPetSocialInfo: Hashable {
    static func == (lhs: NewPetSocialInfo, rhs: NewPetSocialInfo) -> Bool {
        (
            lhs.id == rhs.id &&
            lhs.socialInfo.maleDogFriendly   == rhs.socialInfo.maleDogFriendly   &&
            lhs.socialInfo.femaleDogFriendly == rhs.socialInfo.femaleDogFriendly &&
            lhs.socialInfo.maleCatFriendly   == rhs.socialInfo.maleCatFriendly   &&
            lhs.socialInfo.femaleCatFriendly == rhs.socialInfo.femaleCatFriendly
        )
    }
    var id = UUID().uuidString
    var socialInfo: SocialInfo = SocialInfo(maleDogFriendly: false, femaleDogFriendly: false, maleCatFriendly: false, femaleCatFriendly: false )
    weak var delegate: NewPetSocialInfoDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    init(socialInfo: SocialInfo) {
        self.socialInfo = socialInfo
    }
}

struct NewPetSocialInfoListCellConfiguration: ContentConfigurable {
    var viewModel: NewPetSocialInfo?

    func makeContentView() -> UIView & UIContentView {
        return NewPetSocialInfoCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NewPetSocialInfoListCellConfiguration {
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        let updateConfiguration = self

        if state.isSwiped {
        }

        return updateConfiguration
    }
}
