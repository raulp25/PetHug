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


