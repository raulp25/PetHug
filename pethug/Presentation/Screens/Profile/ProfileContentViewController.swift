//
//  UserProfile.swift
//  pethug
//
//  Created by Raul Pena on 16/10/23.
//

import UIKit
import Combine
import PhotosUI
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
    private let viewModel = ProfileViewModel(updateUserUC: UpdateUser.composeUpdateUserUC(),
                                             imageService: ImageService())
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        fetchUser()
        setup()
        
        viewModel.state
            .handleThreadsOperator()
            .sink { [weak self] state in
                switch state {
                case .loaded:
                    self?.profileImageView.image = self?.newImage!
                case .error(let error):
                    print("error updating profile image: => \(error)")
                    self?.alert(message: "Hubo un error, intenta de nuevo", title: "Error")
                default:
                    print("")
                }
            }.store(in: &cancellables)
    }
    
    //MARK: - Private actions
    @objc private func didTapSingOut() {
        try! AuthService().signOut()
    }
    
    @objc private func didTapProfilePic() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        coordinator?.rootViewController.present(phPicker, animated: true)
        
    }
    
    //MARK: - Setup
    private func setup() {
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(cameraIcon)
        view.addSubview(logoutBtn)
        view.addSubview(deleteAccBtn)
        
        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingLeft: 30
        )
        
        containerView.centerX(
            inView: view,
            topAnchor: titleLabel.bottomAnchor,
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
    func fetchUser() {
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
    
}

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





