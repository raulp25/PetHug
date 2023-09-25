//
//  ContentStateViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit

final class ContentStateViewController: UIViewController {
    private var state: State?
    var shownViewController: UIViewController?
    let headerView = PetsViewHeaderViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(headerView)
        view.addSubview(headerView.view)
        headerView.didMove(toParent: self)
        headerView.view.setHeight(70)
        ////Check at the end if we leave the PetviewController as it is or we change the child controller and add this padding tops mods
        headerView.view.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
//            ,
//            paddingTop:
//                UIScreen.main.bounds.size.height <= 700 ?
//                40 :
//                    UIScreen.main.bounds.size.height <= 926 ?
//                    60 :
//                        75
//            )
        )
        
        if state == nil {
            transition(to: .loading)
        }
    }
    
    func transition(to newState: State) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        vc.view.alpha = 0
        add(vc)
        shownViewController = vc
        state = newState
        vc.view.anchor(top: headerView.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
            vc.view.alpha = 1
        }
    }
    
    func action() {
        
    }
    
}

private extension ContentStateViewController {
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case let .failed(error):
            return ErrorViewController(retryAction: action, err: error)
        case let .render(viewController):
            return viewController
        }
    }
}

extension ContentStateViewController {
    enum State {
        case loading
        case failed(PetsError)
        case render(UIViewController)
    }
}
