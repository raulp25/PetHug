//
//  InAppCoordinator+TabBar.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import Foundation

extension InAppCoordinator {
    enum TabBar: String, CaseIterable {
        case home = "Home"
        case add = "Add"
        case favorites = "Favorites"
        case about = "About"

        var imageName: String {
            switch self {
            case .home:
                return "house.fill"
            case .add:
                return "pawprint"
            case .favorites:
                return "person.2.fill"
            case .about:
                return "rectangle.portrait.on.rectangle.portrait.fill"
            }
        }

        var tag: Int {
            switch self {
            case .home:
                return 0
            case .add:
                return 1
            case .favorites:
                return 2
            case .about:
                return 3
            }
        }
    }
}
