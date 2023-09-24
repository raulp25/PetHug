//
//  LaunchViewController.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

final class LaunchViewController: UIViewController {
    
    //MARK: - Properties
    
    var countDown: Double = 1
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setup()
    }
    
    //MARK: - Setup
    func setup() {
        let launchView = LaunchView()
        view.addSubview(launchView)
        launchView.fillSuperview()
    }
    
}
