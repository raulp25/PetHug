//
//  UserProfile.swift
//  pethug
//
//  Created by Raul Pena on 16/10/23.
//

import UIKit

final class ProfileContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, logoutBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    
//    private lazy var hStackFirstRow: UIStackView = {
//        let stack = UIStackView()
//        stack.backgroundColor = .white
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.distribution = .fillEqually
//        stack.spacing = 30
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
//
//    private lazy var hStackAll: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [allLabel, allCheckMarkButton])
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.distribution = .equalSpacing
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
    
    lazy private var profileImageView: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.backgroundColor = customRGBColor(red: 0, green: 61, blue: 44)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private lazy var logoutBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Filtrar", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 255, green: 176, blue: 42)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(didTapSingOut), for: .touchUpInside)
        return btn
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Mis animales favoritos"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    //MARK: - Private properties
    private let authService: AuthServiceProtocol
    private let fetchUserUC: DefaultFetchUserUC
    
    //MARK: - Internal properties
    weak var delegate: PetsViewHeaderDelegate?
    
    init(authService: AuthServiceProtocol, fetchUserUC: DefaultFetchUserUC) {
        self.authService = authService
        self.fetchUserUC = fetchUserUC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapSingOut() {
        try! AuthService().signOut()
    }
    
    @objc private func didTapProfilePic() {
        
    }
    
    //MARK: - Setup
    func setup() {
        
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: sidePadding)
        profileImageView.setDimensions(height: 60, width: 60)
        
        titleLabel.centerX(inView: view, topAnchor: view.topAnchor, paddingTop: paddingTop)
        titleLabel.setWidth(150)
        
    }
    
}


