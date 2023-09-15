//
//  LoginViewController.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Private components
    
//    CHECAR SI AFECTO EL withoutAutoLayout - respuesta: parece que no afecta pero vamos a dejarlo para el futuro aver
//    si afecta o no
    private let containerView = UIView(withAutolayout: true)
    private let childContainerView = UIView(withAutolayout: true)
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "bull"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    private let titleLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Welcome Back!"
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let emailTextField = AuthTextField(
        viewModel: .init(
            type: .email,
            placeholderOption: .custom("Email address"),
            returnKey: .continue
        )
    )
    
    private let testTextField = AuthTextField(
        viewModel: .init(
            type: .email,
            placeholderOption: .custom("email test"),
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
    
    private lazy var vStack2: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [loginBtn, createAccountBtn])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    private let viewModel = LoginViewModel(authService: AuthService())
    private var subscriptions = Set<AnyCancellable>()
    private var keyboardPublisher: AnyCancellable?
    //check if i delete this
    private var flowLayoutConstraint: NSLayoutConstraint!
    
    //MARK: - Internal properties
    weak var coordinator: LoginCoordinator?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 248, green: 111, blue: 14)
        setupKeyboardHiding()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardPublisher = nil
        keyboardPublisher?.cancel()
    }
    
    //MARK: - Actions
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
        view.endEditing(true)
        coordinator?.startCreateAccountCoordinator()
    }
   
   
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField
        else {
            return
        }
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview?.superview?.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        let intOne: CGFloat = 10, intTwo:CGFloat = 150

        if (textFieldBottomY + intOne) > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY + intTwo
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
//  private methods
    private func setupKeyboardHiding(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - setup
    func setup() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(childContainerView)
        containerView.addSubview(googleSignInBtn)
        
        let padding: CGFloat = 30

        flowLayoutConstraint = containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        flowLayoutConstraint.isActive = true
        
        containerView.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        
        iconImageView.centerX(
            inView: containerView,
            topAnchor: containerView.topAnchor,
            paddingTop: 50
        )
        
        iconImageView.setDimensions(height: 230, width: 230)
        
        childContainerView.addSubview(titleLabel)
        childContainerView.addSubview(vStack)
        childContainerView.addSubview(forgotPasswordContainerView)
        childContainerView.addSubview(vStack2)
        
        childContainerView.anchor(
            top: iconImageView.bottomAnchor,
            left: containerView.leftAnchor,
            bottom: view.bottomAnchor,
            right: containerView.rightAnchor
        )
        
        childContainerView.layer.cornerRadius = 30
        childContainerView.backgroundColor = .white
        
        titleLabel.anchor(
            top: childContainerView.topAnchor,
            left: childContainerView.leftAnchor,
            paddingTop: 30,
            paddingLeft: padding
        )
        
        vStack.anchor(
            top: titleLabel.bottomAnchor,
            left: childContainerView.leftAnchor,
            right: childContainerView.rightAnchor,
            paddingTop: 20,
            paddingLeft: padding,
            paddingRight: padding
        )
        
        forgotPasswordContainerView.anchor(
            top: vStack.bottomAnchor,
            left: childContainerView.leftAnchor,
            right: childContainerView.rightAnchor,
            paddingTop: 8,
            paddingLeft: padding,
            paddingRight: padding
        )
        forgotPasswordContainerView.addSubview(forgotPasswordBtn)
        forgotPasswordBtn.anchor(
            top: forgotPasswordContainerView.topAnchor,
            bottom: forgotPasswordContainerView.bottomAnchor,
            right: forgotPasswordContainerView.rightAnchor
        )
        
        
        vStack2.anchor(
            top: forgotPasswordContainerView.bottomAnchor,
            left: childContainerView.leftAnchor,
            right: childContainerView.rightAnchor,
            paddingTop: 20,
            paddingLeft: padding,
            paddingRight: padding
        )
       
        googleSignInBtn.anchor(
            left: containerView.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: containerView.rightAnchor,
            paddingLeft: padding,
            paddingRight: padding
        )
        
    }

}

extension LoginViewController: AuthTextFieldDelegate {
    func textFieldShouldReturn(_ textField: AuthTextField) -> Bool {
        if textField == emailTextField {
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
