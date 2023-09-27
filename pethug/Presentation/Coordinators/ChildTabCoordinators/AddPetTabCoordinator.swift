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
        let viewModel = AddPetViewModel(fetchPetsUC: FetchPets.composeFetchPetsUC())
        viewModel.navigation = self
        let vc = AddPetViewController(viewModel: viewModel)
        rootViewController.pushViewController(vc, animated: true)
    }
    
    
}

extension AddPetTabCoordinator: AddPetNavigatable {
    func startAddPetFlow() {
        let child = NewPetCoordinator()
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }    
}

