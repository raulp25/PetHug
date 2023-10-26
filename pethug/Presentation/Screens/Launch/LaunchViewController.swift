//
//  LaunchViewController.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit
import SwiftUI

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

struct LaunchViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LaunchViewController {
        LaunchViewController()
    }
    
    func updateUIViewController(_ uiViewController: LaunchViewController, context: Context) {
        
    }
    
typealias UIViewControllerType = LaunchViewController

}

struct ViewController_Previews4: PreviewProvider {
    static var previews: some View {
        LaunchViewRepresentable()
    }
}
