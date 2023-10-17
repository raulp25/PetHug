//
//  LoginCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

final class LoginCoordinator: NSObject, StateCoordinator {
    var parentCoordinator: ApplicationCoordinator?
    
    var childCoordinators: [NavCoordinator] = .init()
    
    var rootViewController: UINavigationController = .init()
    
    override init() {
        rootViewController.navigationBar.tintColor = .white
    }
    
    func start() {
        let vc = LoginViewController()
        vc.coordinator = self
        rootViewController.delegate = self
        rootViewController.pushViewController(vc, animated: true)
        
    }
    
    func startCreateAccountCoordinator() {
        let child = CreateAccountCoordinator(rootViewController: rootViewController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    deinit {
        print("✅ Deinit LogInCoordinator")
        
    }
    
}


extension LoginCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a joinFacebookVc
        if let createAccountVC = fromViewController as? CreateAccountViewController {
            // We're popping a joinFacebookVc; end its coordinator
            childDidFinish(createAccountVC.coordinator)
        }


    }
}
