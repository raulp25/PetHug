//
//  SideMenuProfileContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 23/10/23.
//

import UIKit
import SwiftUI
import Combine
import SDWebImage

final class SideMenuProfileContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var pethugContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.isUserInteractionEnabled = true
        uv.backgroundColor = customRGBColor(red: 0, green: 171, blue: 187)
        return uv
    }()
    
    let iconImage: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.image = UIImage(named: "launch3")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    
    private let pethugLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
       label.attributedLightBoldColoredText(
           lightText: "Pet",
           boldText: "hug",
           colorRegularText: .black,
           colorBoldText: .white,
           fontSize: 20
       )
       return label
    }()
    
    private let borderBottom: UIView = {
        let uv = UIView()
        uv.backgroundColor = customRGBColor(red: 200, green: 200, blue: 200)
        uv.layer.cornerRadius = 10
        return uv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Sesión"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        uv.layer.cornerRadius = 40
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
        iv.layer.cornerRadius = 40
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var logoutBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cerrar sesión", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapSingOut), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Private properties
    private let viewModel = ProfileViewModel(updateUserUC: UpdateUser.composeUpdateUserUC(),
                                             deleteUserUC: DeleteUser.composeDeleteUserUC(),
                                             imageService: ImageService(),
                                             authService:  AuthService())
    private let authService: AuthServiceProtocol
    private let fetchUserUC: DefaultFetchUserUC
    private var cancellables = Set<AnyCancellable>()
    
    private var newImage: UIImage? = nil
    //MARK: - Internal properties
    weak var coordinator: ProfileTabCoordinator?
    
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
        
        viewModel.state
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .loading:
                    break
                case .loaded:
                    break
                case .error(_):
                    self?.handleError(message: "Hubo un error, intenta de nuevo", title: "Error")
                case .deleteUserError:
                    self?.handleError(message: "Hubo un error eliminando tu usuario, intenta de nuevo o cierra tu sesion e inicia sesión de nuevoe y luego elimina tu cuenta", title: "Error Usuario")
                case .networkError:
                    self?.handleError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
                }
                
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        fetchUser()
    }
    
    //MARK: - Setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(pethugContainer)
        pethugContainer.addSubview(pethugLabel)
        pethugContainer.addSubview(iconImage)
        
        view.addSubview(containerView)
        containerView.addSubview(profileImageView)
        
        view.addSubview(logoutBtn)
        
        pethugContainer.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
        pethugContainer.setHeight(130)
        
        iconImage.center(
            inView: pethugContainer,
            yConstant: -20
        )
        iconImage.setDimensions(height: 60, width: 60)
        
        pethugLabel.centerX(
            inView: iconImage,
            topAnchor: iconImage.bottomAnchor,
            paddingTop: 5
        )
        
        containerView.anchor(
            top: pethugContainer.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 35,
            paddingLeft: 20
        )
        containerView.setDimensions(height: 80, width: 80)
    
        profileImageView.center(
            inView: containerView
        )
        profileImageView.setDimensions(height: 80, width: 80)
        
        logoutBtn.centerY(
            inView: containerView,
            leftAnchor: containerView.rightAnchor,
            paddingLeft: 25
        )
        logoutBtn.setDimensions(height: 32, width: 145)
        
    }
    
    //MARK: - Private actions
    @objc private func didTapSingOut() {
        guard NetworkMonitor.shared.isConnected == true else {
            handleError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
            return
        }
        try! AuthService().signOut()
    }
    
    //MARK: - Private methods
    private func fetchUser() {
        Task {
            do {
                let user = try await fetchUserUC.execute()
                viewModel.user = user
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
    
    
    private func handleError(message: String, title: String = ""){
        view.isUserInteractionEnabled = true
        alert(message: message, title: title)
    }
}
