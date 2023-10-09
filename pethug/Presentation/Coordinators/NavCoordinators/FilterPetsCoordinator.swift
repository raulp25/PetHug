//
//  FilterPetsCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

final class FilterPetsCoordinator: NavCoordinator {
    // MARK: - Properties
    var childCoordinators = [Coordinator]()
    var rootViewController: UINavigationController = .init()
    weak var parentCoordinator: HomeTabCoordinator?
    var pet: Pet?

    // MARK: - LifeCycle
    func start() {
        let vc = FilterPetsContentViewController()
        parentCoordinator?.rootViewController.pushViewController(vc, animated: true)
    }

    deinit {
        print("✅ Deinit FilterPetsCoordinator")
    }
}





