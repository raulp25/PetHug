//
//  InAppCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import Combine
import UIKit

final class InAppCoordinator: StateCoordinator, ChildControllerManagable {
    var childCoordinators: [NavCoordinator] = [NavCoordinator]()

    weak var parentCoordinator: ApplicationCoordinator?

    let rootViewController = InAppContainerRootViewController()
    let manager = InAppManager()

    // MARK: - start
    func start() {
        rootViewController.coordinator = self

        let tabBarVC = InAppTabBarController()
        setUpTabBarChildCoordinators(vc: tabBarVC)

        let sideMenuVC = SideMenuViewController()
        sideMenuVC.delegate = rootViewController

        let mainView = tabBarVC.view!
        let sideMenuView = sideMenuVC.view!

        rootViewController.mainContainerView.addSubview(mainView)
        rootViewController.sideMenuContainerView.addSubview(sideMenuView)

//        mainView.pin(to: rootViewController.mainContainerView)
        mainView.fillSuperview()
//        sideMenuView.pin(to: rootViewController.sideMenuContainerView)
        sideMenuView.fillSuperview()

        rootViewController.addChild(tabBarVC)
        rootViewController.addChild(sideMenuVC)

        setupGestures()
        resetUserDefaultsKeys()
    }

    func startChildTabCoordinator(with tab: TabBar) {
        var childCoordinator: ChildTabCoordinator!
        switch tab {
        case .home:
            childCoordinator = HomeTabCoordinator()
        case .favorites:
            childCoordinator = FavoriteTabCoordinator()
        case .add:
            childCoordinator = AddPetTabCoordinator()
        case .about:
            childCoordinator = HomeTabCoordinator()
        }

        childCoordinator.start()
        childCoordinator.parentCoordinator = self
        childCoordinators.append(childCoordinator)
    }

    func startSettingsFlow() {
        let child = SettingsCoordinator()
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    // MARK: - setup
    private func setUpTabBarChildCoordinators(vc: UITabBarController) {
        var tabBarVCs = [UINavigationController]()
        TabBar.allCases.forEach { tab in
            startChildTabCoordinator(with: tab)
            let tabBarVC = childCoordinators[tab.tag].rootViewController
            setUpTabBarComponents(for: tab, with: tabBarVC)
            tabBarVCs.append(tabBarVC)
        }
        vc.viewControllers = tabBarVCs
        vc.selectedIndex = 0
    }

    private func setUpTabBarComponents(for tab: TabBar, with vc: UIViewController) {
        vc.tabBarItem = .init(title: nil, image: UIImage(systemName: tab.imageName), selectedImage: UIImage(systemName: tab.imageName))    
        vc.tabBarItem.tag = tab.tag
    }

    private func setupGestures() {
        let sideMenuPan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        rootViewController.sideMenuContainerView.addGestureRecognizer(sideMenuPan)

        // all the vc's has the option to show the side menu like messenger
        for coordinator in childCoordinators {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            let tabVC = coordinator.rootViewController.viewControllers.first
            tabVC!.view.addGestureRecognizer(pan)
            pan.delegate = tabVC as? any UIGestureRecognizerDelegate
        }
    }
    
    private func resetUserDefaultsKeys() {
        for key in FilterKeys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        
        
    }

    // MARK: - Private actions
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            rootViewController.handleGestureChanged(gesture: gesture)

        } else if gesture.state == .ended {
            rootViewController.handleGestureEnded(gesture: gesture)
        }
    }

    // MARK: - Internal actions
    func showSideMenu() {
        rootViewController.sideMenuState = .open
    }

    func hideSideMenu() {
        rootViewController.sideMenuState = .closed
    }

    deinit {
        print("✅ Deinit InAppCoordinator")
    }
}

