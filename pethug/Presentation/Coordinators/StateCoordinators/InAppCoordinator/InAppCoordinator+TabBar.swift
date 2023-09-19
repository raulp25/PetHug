//
//  InAppCoordinator+TabBar.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import Foundation

extension InAppCoordinator {
    enum TabBar: String, CaseIterable {
        case chats = "Chats"
        case calls = "Calls"
        case people = "People"
        case stories = "Stories"

        var imageName: String {
            switch self {
            case .chats:
                return "house.fill"
            case .calls:
                return "heart.fill"
            case .people:
                return "person.2.fill"
            case .stories:
                return "rectangle.portrait.on.rectangle.portrait.fill"
            }
        }

        var tag: Int {
            switch self {
            case .chats:
                return 0
            case .calls:
                return 1
            case .people:
                return 2
            case .stories:
                return 3
            }
        }
    }
}
