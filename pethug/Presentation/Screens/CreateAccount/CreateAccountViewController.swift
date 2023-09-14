//
//  CreateAccountViewController.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import Combine
import UIKit

class CreateAccountViewController: UIViewController {
    
    //MARK: - Private components
    
//    CHECAR SI AFECTO EL withoutAutoLayout - respuesta: parece que no afecta pero vamos a dejarlo para el futuro aver
//    si afecta o no
    private let containerView = UIView(withAutolayout: true)
    private let childContainerView = UIView()
    
    private let backgroundImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "orange"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var plusPhotoImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "plus.circle"))
        iv.tintColor = .white.withAlphaComponent(0.73)
        iv.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfilePhotoSelect))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()


    private let titleLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Create account"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "pentagon"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .orange.withAlphaComponent(0.6)
        return iv
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let usernameTextField = AuthTextField(
        viewModel: .init(
            type: .name,
            placeholderOption: .custom("Enter your name"),
            returnKey: .continue
        )
    )
    
    private let emailTextField = AuthTextField(
        viewModel: .init(
            type: .email,
            placeholderOption: .custom("Mobile number or email address"),
            returnKey: .continue
        )
    )
    
    
    private let passwordTextField = AuthTextField(
        viewModel: .init(
            type: .password,
            placeholderOption: .custom("Password"),
            returnKey: .done
        )
    )
    
    private lazy var forgotPasswordContainerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()

    private lazy var forgotPasswordBtn: UIButton = {
        let btn: UIButton = .createTextButton(with: "Forgot Password?")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        return btn
    }()
    
    private lazy var loginBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Log in"))
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    
    private lazy var createAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedRegularBoldColoredText(regularText: "New to Pet Hug?", boldText: "Create Account")
        btn.addTarget(self, action: #selector(goToCreateNewAccount), for: .touchUpInside)
        return btn
    }()
    
    private lazy var googleSignInBtn: GradientUIViewButton = {
        let button = GradientUIViewButton()
        button.title.text = "Sign in with Google"
        button.setImage(image: UIImage(systemName: "snowflake")!, withDimensions: Dimensions(height: 25, width: 25))
        button.setHeight(50)
        button.startColor = customRGBColor(red: 243, green: 117, blue: 121)
        button.endColor = customRGBColor(red: 243, green: 117, blue: 121)
//
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleResetPassword))
//        button.addGestureRecognizer(gesture)
        return button
    }()
    
    
    //MARK: - Private properties
    private var viewModel = CreateAcoountViewModel(authService: AuthService())
    private var subscriptions = Set<AnyCancellable>()
    private var keyboardPublisher: AnyCancellable?
    //check if i delete this
    private var flowLayoutConstraint: NSLayoutConstraint!
    
    //MARK: - Internal properties
    weak var coordinator: CreateAccountCoordinator?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 248, green: 111, blue: 14)
        hideKeyboardWhenTappedAround()
        setup()
        
        viewModel.state
            .handleThreadsOperator()
            .sink { [weak self] currentState in
                guard let self else { return }
                switch currentState {
                case .loading:
                    self.loginBtn.isLoading = true
                case .success:
                    self.loginBtn.isLoading = false
                case let.error(err):
                    self.loginBtn.isLoading = false
                    self.alert(message: err.localizedDescription, title: "Error")
                }
            }.store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if keyboardPublisher == nil {
            keyboardPublisher = keyboardListener()
                .sink(receiveValue: { [weak self] keyboard in
                    switch keyboard.state {
                    case .willShow:
                        self?.manageKeyboardChange(height: keyboard.height)
                    case .willHide:
                        self?.manageKeyboardChange(height: 0)
                    }
                })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(":view will disapea CREATE ACC '''' =>")
        backgroundImageView.removeFromSuperview()
        keyboardPublisher = nil
        keyboardPublisher?.cancel()
    }
    
    //MARK: - Actions
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        view.endEditing(true)
        
        present(picker, animated: true, completion: nil)
    }
    
    
    @objc func login() {
        print(": => login clicked")
        guard
            let validFirstName = emailTextField.isValidText(),
            let validSurname = passwordTextField.isValidText() else {
            return
        }
//        Task {
//            await viewModel.login(email: emailTextField.textField.text, password: passwordTextField.textField.text)
//        }
    }
    
    @objc private func forgotPassword() {
        // TODO: Create forgot password flow after first release
        print(": => forgot password clicked")
    }
    
    @objc func goToCreateNewAccount() {
//        coordinator?.startCreateAccountCoordinator()
    }
    
    //MARK: - Private Methods
    private func manageKeyboardChange(height: CGFloat) {
        let bottomPadding: CGFloat = 20
        
        if height != 0 {
            flowLayoutConstraint.constant = (height - (view.frame.height - vStack.frame.maxY)) - bottomPadding
        } else {
            flowLayoutConstraint.constant = height
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    let paddintTop = UIScreen.main.bounds.height * 0.05
    //MARK: - setup
    func setup() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
//        emailTextField.setHeight(55)
//        passwordTextField.setHeight(55)
        
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        view.addSubview(containerView)
        containerView.addSubview(plusPhotoImageView)
        containerView.addSubview(childContainerView)
        containerView.addSubview(googleSignInBtn)
        
        let padding: CGFloat = 20

        flowLayoutConstraint = containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        flowLayoutConstraint.isActive = true
        
        containerView.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        
        plusPhotoImageView.centerX(
            inView: containerView,
            topAnchor: containerView.topAnchor,
            paddingTop: 50
        )
        
        plusPhotoImageView.setDimensions(height: 180, width: 180)
        
        childContainerView.addSubview(titleLabel)
        childContainerView.addSubview(iconImageView)
        childContainerView.addSubview(vStack)
        
        childContainerView.anchor(
            top: plusPhotoImageView.bottomAnchor,
            left: containerView.leftAnchor,
            bottom: view.bottomAnchor,
            right: containerView.rightAnchor,
            paddingTop: CGFloat(Int(paddintTop))
        )
        print("paddingTop ls: => \(paddintTop)")
        
        childContainerView.layer.cornerRadius = 30
        childContainerView.backgroundColor = .white
        
        titleLabel.anchor(
            top: childContainerView.topAnchor,
            left: childContainerView.leftAnchor,
            paddingTop: 30,
            paddingLeft: padding
        )
        
        iconImageView.centerY(
            inView: titleLabel,
            leftAnchor: titleLabel.rightAnchor,
            paddingLeft: 10
        )
        
        iconImageView.setDimensions(height: 20, width: 20)
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: childContainerView.leftAnchor,
            right: childContainerView.rightAnchor,
            paddingTop: 20,
            paddingLeft: padding,
            paddingRight: padding
        )
        
//        forgotPasswordContainerView.addSubview(forgotPasswordBtn)
//        forgotPasswordBtn.anchor(
//            top: forgotPasswordContainerView.topAnchor,
//            bottom: forgotPasswordContainerView.bottomAnchor,
//            right: forgotPasswordContainerView.rightAnchor
//        )
//
       
        googleSignInBtn.anchor(
            top: vStack.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: 50,
            paddingLeft: padding,
            paddingRight: padding
        )
        
    }
   
}

// MARK: - UIImagePickerControllerDelegate
extension CreateAccountViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        viewModel.profileImage = selectedImage
        
        plusPhotoImageView.layer.cornerRadius = plusPhotoImageView.frame.width / 2
        plusPhotoImageView.layer.masksToBounds = true
        plusPhotoImageView.layer.borderColor = UIColor.white.cgColor
        plusPhotoImageView.layer.borderWidth = 0.5
        plusPhotoImageView.image = selectedImage.withRenderingMode(.alwaysOriginal)
//        plusPhotoImageView.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true)
    }
    
}


extension CreateAccountViewController: AuthTextFieldDelegate {
    func textFieldShouldReturn(_ textField: AuthTextField) -> Bool {
//        if textField == usernameTextField {
//            textField.textField.resignFirstResponder()
//            emailTextField.becomeFirstResponder()
//        }
        
        if textField == emailTextField {
            //check if we leave this behavior or we directly assign
//            the password as first responder
            textField.textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
            
        } else {
            // login
            login()
            textField.textField.resignFirstResponder()
            print(": => keyboard continue button login clicked textfieldShouldReturn")
        }
        return true
    }
}


