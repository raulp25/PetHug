//
//  ProfileCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 16/10/23.
//

import UIKit

final class ProfileTabCoordinator: ChildTabCoordinator {
    var childCoordinators: [NavCoordinator] = .init()
    
    var parentCoordinator: InAppCoordinator?
    
    var rootViewController: UINavigationController = .init()
    
    func start() {
        let vc = ProfileContentViewController(authService: AuthService(),
                                              fetchUserUC: FetchUser.composeFetchUserUC()
                                             )
        rootViewController.pushViewController(vc, animated: true)
    }
}




