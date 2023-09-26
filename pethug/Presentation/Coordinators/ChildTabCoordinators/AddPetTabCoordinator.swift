//
//  AddPetCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 25/09/23.
//

import UIKit

final class AddPetTabCoordinator: ChildTabCoordinator {
    var childCoordinators: [NavCoordinator] = .init()
    
    var parentCoordinator: InAppCoordinator?
    
    var rootViewController: UINavigationController = .init()
    
    func start() {
        let vc = PetsViewController(viewModel: .init(fetchPetsUC: FetchPets.composeFetchPetsUC()))
        rootViewController.pushViewController(vc, animated: true)
    }
}

