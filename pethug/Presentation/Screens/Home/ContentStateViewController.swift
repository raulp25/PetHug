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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if state == nil {
            transition(to: .loading)
        }
    }
    
    func transition(to newState: State) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
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
            return ErrorViewController(err: error)
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
