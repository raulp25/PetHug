//
//  SettingsCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import UIKit

final class SettingsCoordinator: NSObject, NavCoordinator {
    weak var parentCoordinator: InAppCoordinator?

    var childCoordinators: [NavCoordinator] = []

    var rootViewController: UINavigationController

    override init() {
        rootViewController = .init()
        rootViewController.modalPresentationStyle = .popover
        super.init()
    }

    func start() {
        let vc = SettingsVC()
        vc.coordinator = self
        rootViewController.setViewControllers([vc], animated: false)
        rootViewController.presentationController?.delegate = self
//        parentCoordinator?.rootViewController.view.transform = .init(scaleX: 0.9, y: 0.9)
//        parentCoordinator?.rootViewController.visibleViewController?.view.transform = .init(scaleX: 0.9, y: 0.9)
        parentCoordinator?.rootViewController.present(rootViewController, animated: true)
//        parentCoordinator?.rootViewController.visibleViewController?.present(rootViewController, animated: true)
    }

    func childDidFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    deinit {
        print("✅ Deinit SettingsCoordinator")
    }
}

extension SettingsCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_: UIPresentationController) {
        childDidFinish()
    }
}

