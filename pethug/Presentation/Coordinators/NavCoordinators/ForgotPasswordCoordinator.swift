//
//  ForgotPasswordCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 17/10/23.
//

import UIKit

final class ForgotPasswordCoordinator: NavCoordinator {
    weak var parentCoordinator: LoginCoordinator?
    
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let vc = ForgotPasswordViewController()
        vc.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("✅ Deinit ForgotPasswordCoordinator")
    }
}



