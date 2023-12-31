//
//  SideMenuViewController.swift
//  pethug
//
//  Created by Raul Pena on 16/09/23.
//

import UIKit

final class SideMenuViewController: UIViewController {
    // MARK: - Private Components
    private lazy var contentVC = SideMenuProfileContentViewController(authService: AuthService(),
                                                                      fetchUserUC: FetchUser.composeFetchUserUC())

    // MARK: - Private Properties
    private let customWidth = UIScreen.main.bounds.width * 0.85
    private var topAnchorConstraint: NSLayoutConstraint!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let window = UIApplication.shared.windows.first else { return }
        let topPadding = window.safeAreaInsets.top

        topAnchorConstraint.constant = topPadding
        topAnchorConstraint.isActive = true
    }

    // MARK: - setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 0, green: 171, blue: 187)

        // sideMenuVC
        addChild(contentVC)
        contentVC.didMove(toParent: self)

        view.addSubview(contentVC.view)

        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        topAnchorConstraint = contentVC.view.topAnchor.constraint(equalTo: view.topAnchor)
        contentVC.view.pinSides(
            to: view
        )
        contentVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: - Public methods
    func reloadUser() {
        contentVC.reloadUser()
    }
}

