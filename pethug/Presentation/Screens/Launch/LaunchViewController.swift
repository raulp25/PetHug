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
    var countDown: Double = 1.5
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 0, green: 171, blue: 187)
        setup()
    }
    
    //MARK: - Setup
    func setup() {
        let launchView = LaunchView()
        view.addSubview(launchView)
        launchView.fillSuperview()
    }
    
}
