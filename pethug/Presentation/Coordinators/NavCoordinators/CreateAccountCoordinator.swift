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
    
//    var user = UserPrivate(id: nil, uuid: "", name: "", profileImageUrlString: "", email: "", dateOfBirth: 0)
//    var password: String?
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
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

