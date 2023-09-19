//
//  PetsViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit

final class PetsViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var contentStateVC = ContentStateViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        title = "Animales"
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        
        add(contentStateVC)
    }
    
}
