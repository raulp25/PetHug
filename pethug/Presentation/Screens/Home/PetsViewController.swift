//
//  PetsViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit

//protocol PetsViewControllerDelegate: AnyObject {
//    func didTap(recipient: Any)
////    func didTap(_: Any)
//}

final class PetsViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var contentStateVC = ContentStateViewController()
    private lazy var contentVc: PetsContentViewController? = nil
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        render([])
    }
    
    // MARK: - setup
    private func setup() {
//        title = "Animales"
        view.backgroundColor = .white
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 7
        add(contentStateVC)
        contentStateVC.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    //MARK: - Private methods
    private func render(_ data: Any) {
        contentVc = PetsContentViewController()
        contentStateVC.transition(to: .render(contentVc!))
        
    }
    
}
