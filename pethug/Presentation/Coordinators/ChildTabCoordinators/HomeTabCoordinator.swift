//
//  HomeTabCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import UIKit

final class HomeTabCoordinator: ChildTabCoordinator {
    var childCoordinators: [NavCoordinator] = .init()
    
    var parentCoordinator: InAppCoordinator?
    
    var rootViewController: UINavigationController = .init()
    
    func start() {
        let vc = PetsViewController()
        rootViewController.pushViewController(vc, animated: true)
    }
}
