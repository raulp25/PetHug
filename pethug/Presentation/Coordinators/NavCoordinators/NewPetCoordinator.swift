//
//  AddPetCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

final class NewPetCoordinator: NavCoordinator {
    // MARK: - Properties
    var childCoordinators = [Coordinator]()
    var rootViewController: UINavigationController = .init()
    weak var parentCoordinator: AddPetTabCoordinator?
    var pet: Pet?

    // MARK: - LifeCycle
    func start() {
        let vc = NewPetViewController()
        vc.pet = pet
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        parentCoordinator?.rootViewController.present(vc, animated: true)
    }

    deinit {
        print("✅ Deinit NewPetCoordinator")
    }
}

extension NewPetCoordinator {
    // This Coordinator is manually popped because the associated
    // view controller was presented modally, not pushed onto the navigation stack.
    // As a result, the UINavigationControllerDelegate won't detect the view controller we're moving from.
    func coordinatorDidFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}



  
