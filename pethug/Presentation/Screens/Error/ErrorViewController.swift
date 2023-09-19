//
//  ErrorViewController.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit

final class ErrorViewController: UIViewController {
    var retryAction: (() -> Void)?
    var err: PetsError
    
    init(retryAction: (() -> Void)? = nil, err: PetsError) {
        self.retryAction = retryAction
        self.err = err
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = ErrorView( error: err)
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}

