//
//  InAppContainerRootViewController+State.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import Foundation

// MARK: - State
extension InAppContainerRootViewController {
    enum SideMenuState {
        case open
        case closed

        var isTabBarControllerInteractive: Bool {
            switch self {
            case .open:
                return false
            case .closed:
                return true
            }
        }

        var isBackDropViewInteractive: Bool {
            switch self {
            case .open:
                return true
            case .closed:
                return false
            }
        }
    }
}
