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
        rootViewController.navigationBar.tintColor = .systemGreen
    }
    
    func start() {
        
    }
    
}


//extension LoginCoordinator: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
//            return
//        }
//
//        if navigationController.viewControllers.contains(fromViewController) {
//            return
//        }
//
//
//    }
//}
