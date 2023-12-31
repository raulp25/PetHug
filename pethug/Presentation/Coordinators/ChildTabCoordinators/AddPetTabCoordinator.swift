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
    
    var viewModel = AddPetViewModel(
        imageService: ImageService(),
        fetchUserPetsUC: FetchUserPets.composeFetchUserPetsUC(),
        deletePetUC: DeletePet.composeDeletePetUC(),
        deletePetFromRepeatedCollectionUC: DeletePetFromRepeatedCollection.composeDeletePetFromRepeatedCollectionUC()
    )
    
    func start() {
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
    
    func startEditPetFlow(pet: Pet) {
        let child = NewPetCoordinator()
        child.pet = pet
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}


