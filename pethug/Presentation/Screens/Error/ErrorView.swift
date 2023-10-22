//
//  ErrorView.swift
//  pethug
//
//  Created by Raul Pena on 18/09/23.
//

import UIKit

final class ErrorView: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Error"
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorMessage: UILabel = {
        let label = UILabel()
        label.text = self.error.localizedDescription
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let error: PetsError
    let retryAction: (() -> Void)?
    
    init(retryAction: (() -> Void)? = nil, error: PetsError) {
        self.retryAction = retryAction
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        let sidesInset = CGFloat(50)
        let width = CGFloat(view.bounds.width - sidesInset)
        
        view.addSubview(titleLabel)
        view.addSubview(errorMessage)
        
        titleLabel.center(inView: view, yConstant: -100)
        titleLabel.setWidth(width)
        errorMessage.centerX(inView: titleLabel, topAnchor: titleLabel.bottomAnchor, paddingTop: 10)
        errorMessage.setWidth(width)
    }
}
