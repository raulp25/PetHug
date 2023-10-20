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
//        rgb(161, 255, 254)
        tabBar.barTintColor =    customRGBColor(red: 251, green: 251, blue: 251)
        tabBar.backgroundColor = customRGBColor(red: 251, green: 251, blue: 251)
        tabBar.isTranslucent = true
        tabBar.clipsToBounds = true
        tabBar.tintColor =  customRGBColor(red: 0, green: 212, blue: 222)
        tabBar.unselectedItemTintColor = customRGBColor(red: 182, green: 190, blue: 203)
    }
}
