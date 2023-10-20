//
//  UserProfile.swift
//  pethug
//
//  Created by Raul Pena on 16/10/23.
//

import UIKit
import SDWebImage

final class ProfileContentViewController: UIViewController {
    //MARK: - Private components
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "General"
        label.font = UIFont.systemFont(ofSize: 50, weight: .light, width: .expanded)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        
        
//        label.font = UIFont.systemFont(ofSize: 55, weight: .light, width: .expanded)
//        let attributedText = NSMutableAttributedString(string: "Perfil")
//        let letterSpacing: CGFloat = 2.5
//        attributedText.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedText.length))
//        label.attributedText = attributedText
        
        return label
    }()
    
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        uv.layer.cornerRadius = 10
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
//        uv.isUserInteractionEnabled = true
//        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    lazy private var profileImageView: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = customRGBColor(red: 237, green: 237, blue: 237)
        iv.image?.withTintColor(.red)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    lazy private var cameraIcon: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.image = UIImage(systemName: "camera")
        iv.tintColor = customRGBColor(red: 255, green: 255, blue: 255)
        iv.image?.withTintColor(.red)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
//        iv.isUserInteractionEnabled = true
//        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private lazy var logoutBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cerrar sesión", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 250, green: 166, blue: 15)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(didTapSingOut), for: .touchUpInside)
        return btn
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [privacyButton, aboutButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
                stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private lazy var privacyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Políticas de privacidad", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 255, green: 166, blue: 15)
        btn.layer.cornerRadius = 8
//        btn.addTarget(self, action: #selector(didTapSingOut), for: .touchUpInside)
        return btn
    }()
    
    private lazy var aboutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sobre nosotros", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 255, green: 166, blue: 15)
        btn.layer.cornerRadius = 8
//        btn.addTarget(self, action: #selector(didTapSingOut), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var deleteAccBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Eliminar cuenta", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
//        btn.addTarget(self, action: #selector(didTapSingOut), for: .touchUpInside)
        return btn
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        fetchUser()
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapSingOut() {
        try! AuthService().signOut()
    }
    
    @objc private func didTapProfilePic() {
        
    }
    
    //MARK: - Setup
    private func setup() {
        
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(cameraIcon)
        view.addSubview(logoutBtn)
//        view.addSubview(vStack)
        view.addSubview(deleteAccBtn)
//        containerView.anchor(
//            top: view.safeAreaLayoutGuide.topAnchor,
//            left: view.leftAnchor,
//            paddingTop: 30,
//            paddingLeft: 30
//        )
//        containerView.setDimensions(height: 120, width: 120)
//
////        profileImageView.fillSuperview()
//        profileImageView.center(inView: containerView)
//        profileImageView.setDimensions(height: 30, width: 30)
//
//        cameraIcon.anchor(
//            bottom: containerView.bottomAnchor,
//            right: containerView.rightAnchor,
//            paddingBottom: 3,
//            paddingRight: 4
//        )
//        cameraIcon.setDimensions(height: 26, width: 26)
//
//        logoutBtn.centerY(
//            inView: containerView,
//            leftAnchor: containerView.rightAnchor,
//            paddingLeft: 20
//        )
//        logoutBtn.setDimensions(height: 30, width: 140)
        
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingLeft: 30
        )
        
        containerView.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 150)
        containerView.setDimensions(height: 145, width: 145)
        
//        profileImageView.fillSuperview()
        profileImageView.center(inView: containerView)
        profileImageView.setDimensions(height: 30, width: 30)
        
        cameraIcon.anchor(
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingBottom: 3,
            paddingRight: 4
        )
        cameraIcon.setDimensions(height: 26, width: 26)
        
        logoutBtn.centerX(inView: containerView, topAnchor: containerView.bottomAnchor, paddingTop: 10)
        logoutBtn.setDimensions(height: 32, width: 145)
        
//        vStack.centerX(inView: logoutBtn, topAnchor: logoutBtn.bottomAnchor, paddingTop: 150)
//        vStack.setWidth(200)
//
//        privacyButton.setHeight(32)
//        aboutButton.setHeight(32)
        
        deleteAccBtn.centerX(inView: logoutBtn, topAnchor: logoutBtn.bottomAnchor, paddingTop: 50)
        deleteAccBtn.setDimensions(height: 32, width: 200)
        
    }
    
    //MARK: - Private methods
    func fetchUser() {
        Task {
            do {
                let user = try await fetchUserUC.execute()
                guard let image = user.profileImageUrl else { return }
                
                let url = URL(string: image)
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.sd_setImage(with: url)
                    self?.profileImageView.fillSuperview()
                }
            } catch {
                print("Error fetching user in profile vc: => \(error)")
            }
        }
    }
    
}



