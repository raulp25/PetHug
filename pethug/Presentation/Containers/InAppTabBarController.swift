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
        tabBar.barTintColor = customRGBColor(red: 244, green: 244, blue: 244)
        tabBar.tintColor = .systemPink
    }
}
