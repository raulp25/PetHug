//
//  PetsViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit
import Combine

//protocol PetsViewControllerDelegate: AnyObject {
//    func didTap(recipient: Any)
////    func didTap(_: Any)
//}

final class PetsViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var contentStateVC = ContentStateViewController()
    private lazy var contentVc: PetsContentViewController? = nil
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: PetsViewModel
    
    // MARK: - LifeCycle
    init(viewModel: PetsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        render([""])
        bind()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            try! AuthService().signOut()
//        })
    }
    
    // MARK: - setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 111, green: 235, blue: 210)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
      
        addChild(contentStateVC)
        view.addSubview(contentStateVC.view)
        contentStateVC.didMove(toParent: self)
        ////Check at the end if we re-vert the paddings strategy in the ContentStateViewController
        contentStateVC.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        contentStateVC.view.layer.borderColor = UIColor.green.cgColor
        contentStateVC.view.layer.borderWidth = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.render([""])
        })
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel
            .state
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case let .loaded(data):
                    self?.render(data)
                case .loading:
                    break
                case let .error(error):
                    print(": => \(error.localizedDescription)")
                    break
                }
            }.store(in: &subscriptions)
    }
    
    //MARK: - Private methods
    private func render(_ data: Any) {
        contentVc = PetsContentViewController()
        contentStateVC.transition(to: .render(contentVc!))
        
    }
    
}
