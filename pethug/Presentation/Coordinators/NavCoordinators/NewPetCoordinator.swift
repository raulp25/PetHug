//
//  AddPetCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

final class NewPetCoordinator: NavCoordinator {
    // MARK: - Properties
    ///Siempre hay que ir pasando el parent rootView a los nuevos coordinators
    var childCoordinators = [Coordinator]()
    var rootViewController: UINavigationController = .init()
    weak var parentCoordinator: AddPetTabCoordinator?
//    private let viewModel = NewMessageViewModel()

    // MARK: - LifeCycle
    func start() {
        let vc = NewPetViewController()
        vc.coordinator = self
        
        vc.modalPresentationStyle = .fullScreen
        parentCoordinator?.rootViewController.present(vc, animated: true)
    }

    deinit {
        print("✅ Deinit NewMessageCoordinator")
    }
}

