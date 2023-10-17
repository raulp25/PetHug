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
        case favorites = "Favoritos"
        case add = "Publicar"
        case profile = "General"

        var imageName: String {
            switch self {
            case .home:
                return "house.fill"
            case .favorites:
                return "heart"
            case .add:
                return "pawprint"
            case .profile:
                return "fireplace"
            }
        }

        var tag: Int {
            switch self {
            case .home:
                return 0
            case .favorites:
                return 1
            case .add:
                return 2
            case .profile:
                return 3
            }
        }
    }
}
