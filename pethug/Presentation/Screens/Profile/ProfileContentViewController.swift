//
//  UserProfile.swift
//  pethug
//
//  Created by Raul Pena on 16/10/23.
//

import UIKit
import SwiftUI
import Combine
import PhotosUI
import SDWebImage

final class ProfileContentViewController: UIViewController {
    //MARK: - Private components
    private let headerView = ProfileViewHeaderViewController()
    private let dummyView = DummyView()
    private let loadingView = LoadingViewController(spinnerColors: [customRGBColor(red: 255, green: 176, blue: 42)])
    
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        uv.layer.cornerRadius = 10
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
    
    private lazy var deleteAccBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Eliminar cuenta", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(didTapDeleteAccount), for: .touchUpInside)
        return btn
    }()
    
    
    //MARK: - Private properties
    private let viewModel = ProfileViewModel(updateUserUC: UpdateUser.composeUpdateUserUC(),
                                             deleteUserUC: DeleteUser.composeDeleteUserUC(),
                                             imageService: ImageService())
    private let authService: AuthServiceProtocol
    private let fetchUserUC: DefaultFetchUserUC
    private var cancellables = Set<AnyCancellable>()
    
    private var newImage: UIImage? = nil
    //MARK: - Internal properties
    weak var coordinator: ProfileTabCoordinator?
    
    //MARK: - LifeCycle
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
        bind()
    }
    
    //MARK: - Bind
    func bind() {
        viewModel.state
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.setLoadingScreen()
                case .loaded:
                    self?.view.isUserInteractionEnabled = true
                    self?.profileImageView.image = self?.newImage!
                    self?.removeLoadingScreen()
                case .error(_):
                    self?.handleError(message: "Hubo un error, intenta de nuevo", title: "Error")
                case .deleteUserError:
                    self?.handleError(message: "Hubo un error eliminando tu usuario, intenta de nuevo o inicia sesión nuevamente y luego elimina tu cuenta", title: "Error Usuario")
                case .networkError:
                    self?.handleError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
                }
                
            }.store(in: &cancellables)
    }
    
    //MARK: - Private actions
    @objc private func didTapProfilePic() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        coordinator?.rootViewController.present(phPicker, animated: true)
        
    }
    
    @objc private func didTapSingOut() {
        guard NetworkMonitor.shared.isConnected == true else {
            handleError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
            return
        }
        try! AuthService().signOut()
    }
    
    @objc private func didTapDeleteAccount() {
        showModal()
    }
    
        @objc private func didTapModalScreen() {
        cancel()
    }
    
    //MARK: - Setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 252, green: 252, blue: 252)
        
        add(headerView)
        
        view.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(cameraIcon)
        
        view.addSubview(logoutBtn)
        view.addSubview(deleteAccBtn)

        
        headerView.view.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            //Responsive for se 3rd gen
            paddingTop:
                UIScreen.main.bounds.size.height <= 700 ?
                40 :
                    UIScreen.main.bounds.size.height <= 926 ?
                    0 :
                        0
        )
        headerView.view.setHeight(130)
        
        containerView.centerX(
            inView: view,
            topAnchor: headerView.view.bottomAnchor,
            paddingTop: 150
        )
        containerView.setDimensions(height: 145, width: 145)
    
        profileImageView.center(
            inView: containerView
        )
        profileImageView.setDimensions(height: 30, width: 30)
        
        cameraIcon.anchor(
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingBottom: 3,
            paddingRight: 4
        )
        cameraIcon.setDimensions(height: 26, width: 26)
        
        logoutBtn.centerX(
            inView: containerView,
            topAnchor: containerView.bottomAnchor,
            paddingTop: 10
        )
        logoutBtn.setDimensions(height: 32, width: 145)
        
        deleteAccBtn.centerX(
            inView: logoutBtn,
            topAnchor: logoutBtn.bottomAnchor,
            paddingTop: 50
        )
        deleteAccBtn.setDimensions(height: 32, width: 200)
        
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
    
    private func setLoadingScreen() {
        view.isUserInteractionEnabled = false
        
        add(loadingView)
        view.bringSubviewToFront(loadingView.view)
        loadingView.view.fillSuperview()
        loadingView.view.backgroundColor = customRGBColor(red: 247, green: 247, blue: 247, alpha: 0.5)
    }
    
    private func removeLoadingScreen() {
        loadingView.remove()
    }
    
    private func handleError(message: String, title: String = ""){
        view.isUserInteractionEnabled = true
        removeLoadingScreen()
        alert(message: message, title: title)
    }
    
    private func deleteUser() {
        dismissModal()
        Task{
            await viewModel.deleteUser()
        }
    }
    
    private func cancel() {
        dismissModal()
    }
    
    private func dismissModal() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            self.dummyView.view.alpha = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { [weak self] in
                self?.dummyView.remove()
                self?.view.layoutIfNeeded()
            })
        }
    }
    //Delete acc modal
    private func showModal(){
        let deleteAccView = Modal(leftButtonAction: cancel,
                                  rightButtonAction: deleteUser,
                                  leftButtonTitle: "Cancelar",
                                  rightButtonTitle: "Eliminar")
        
        add(dummyView)
        view.bringSubviewToFront(dummyView.view)
        dummyView.view.addSubview(deleteAccView)
        
        dummyView.view.fillSuperview()
        dummyView.view.alpha = 0
        dummyView.view.backgroundColor = .black.withAlphaComponent(0.3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapModalScreen))
        dummyView.view.isUserInteractionEnabled = true
        dummyView.view.addGestureRecognizer(tapGesture)
        
        deleteAccView.center(
            inView: dummyView.view
        )
        deleteAccView.setDimensions(height: 200, width: view.frame.size.width - 100)
        deleteAccView.layer.cornerRadius = 15
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.dummyView.view.alpha = 1
        }
        self.view.layoutIfNeeded()
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ProfileContentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        coordinator?.rootViewController.dismiss(animated: true)
        
        for image in results {
            image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let error = error {
                    print("error loading image object: => \(error)")
                }
                
                if let image = object as? UIImage {
                    self?.newImage = image
                    Task {
                        await self?.viewModel.updateProfilePic(image: image)
                    }
                }
            }
        }
    }
}


