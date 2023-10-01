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
    private let headerView = PetsViewHeaderViewController()
    
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
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            try! AuthService().signOut()
//        })
    }
    
    
    // MARK: - setup
    private func setup() {
//        view.backgroundColor = customRGBColor(red: 111, green: 235, blue: 210)
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        view.isMultipleTouchEnabled = false
        view.isExclusiveTouch = true
        
        add(headerView)
        headerView.view.setHeight(70)
        headerView.view.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop:
                UIScreen.main.bounds.size.height <= 700 ?
                40 :
                    UIScreen.main.bounds.size.height <= 926 ?
                    60 :
                        75
        )
        
        add(contentStateVC)
        contentStateVC.view.anchor(top: headerView.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
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
    private func render(_ data: [Pet]) {
//        let snapData: [PetsContentViewController.SnapData] = [
//            .init(key: .pets, values: data.map { .pet($0) })
//        ]
        let snapData: [PetsContentViewController.SnapData] = [
//            .init(key: .pets, values: data.map { .pet($0) })
        ]
        
        if contentStateVC.shownViewController == contentVc {
            contentVc?.snapData = snapData
        } else {
            contentVc = PetsContentViewController(snapData: snapData)
            contentStateVC.transition(to: .render(contentVc!))
        }
        
    }
    
}
