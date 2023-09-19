//
//  InAppTabBarController.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import UIKit

final class InAppTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoot()
    }

    // MARK: - setup
    private func setupRoot() {
        view.clipsToBounds = false
        tabBar.backgroundColor = .systemYellow.withAlphaComponent(0.4)
        tabBar.barTintColor = .green
        tabBar.tintColor = .systemPink
    }
}
