//
//  CreateAccountCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import UIKit

final class CreateAccountCoordinator: NavCoordinator {
    weak var parentCoordinator: LoginCoordinator?
    
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        rootViewController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func start() {
        let vc = CreateAccountViewController()
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("✅ Deinit CreateAccountCoordinator")
    }
}

