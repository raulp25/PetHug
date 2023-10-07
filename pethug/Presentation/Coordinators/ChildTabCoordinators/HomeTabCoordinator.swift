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
        let viewModel: PetsViewModel = .init(fetchPetsUC: FetchPets.composeFetchPetsUC())
        viewModel.navigation = self
        let vc = PetsViewController(viewModel: viewModel)
        rootViewController.pushViewController(vc, animated: true)
    }
}

extension HomeTabCoordinator: PetsNavigatable {
    func tapped(pet: Pet) {
     let vc = PetContentViewController()
        rootViewController.pushViewController(vc, animated: true)
    }
}
