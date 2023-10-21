//
//  LoginViewController.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

protocol LoginViewControllerNavigatable: AnyObject{
    func didTapForgotPassword()
}

class LoginViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(withAutolayout: true)
        sv.isDirectionalLockEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        sv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return sv
    }()
    
    private let containerView: UIView = {
       let uv = UIView(withAutolayout: true)
        return uv
    }()
    private let childContainerView: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .clear
        return uv
    }()
    
    private let iconImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "login"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    private let titleLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
       label.attributedLightBoldColoredText(
           lightText: "pet",
           boldText: "hug",
           colorRegularText: .black,
           colorBoldText: .white,
           fontSize: 60
       )
       return label
    }()
    
    let blurView: UIVisualEffectView = {
        let vv = UIVisualEffectView()
        vv.clipsToBounds = true
        vv.layer.cornerRadius = 7
        vv.translatesAutoresizingMaskIntoConstraints = false
        vv.backgroundColor = customRGBColor(red: 255, green: 255, blue: 256, alpha: 0.85)
       return vv
    }()
    
    let blurEffect  = UIBlurEffect(style: .light)
    
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
            placeholderOption: .custom("Correo electrónico"),
            returnKey: .continue
        )
    )
    
    private let passwordTextField = AuthTextField(
        viewModel: .init(
            type: .password,
            placeholderOption: .custom("Contraseña"),
            returnKey: .done
        )
    )

    private lazy var forgotPasswordContainerView: UIView = {
        let uv = UIView(withAutolayout: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPassword))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()

    private lazy var forgotPasswordBtn: UIButton = {
        let btn: UIButton = .createTextButton(with: "Olvidé contraseña", color: .black)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        return btn
    }()

    
    private lazy var loginBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Iniciar sesión"))
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20.7, weight: .bold)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private lazy var createAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedRegularBoldColoredText(regularText: "No tienes cuenta?", boldText: " Registrate", color: .white, fontSize: 16)
        btn.addTarget(self, action: #selector(goToCreateNewAccount), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Private properties
    private let viewModel = LoginViewModel(authService: AuthService())
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Internal properties
    weak var coordinator: LoginCoordinator?
    weak var navigation: LoginViewControllerNavigatable?
    
    var alert: Bool = false {
        didSet {
            if alert == true {
                self.alert(message: "Enviamos un link a tu correo electrónico para restablecer tu contraseña", title: "Envío exitóso")
                alert = false
            }
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    //MARK: - Actions
    @objc func login() {
        print(": => login clicked")
        guard
            let _ = emailTextField.isValidText(),
            let _ = passwordTextField.isValidText() else {
            return
        }
        Task {
            await viewModel.login(email: emailTextField.textField.text, password: passwordTextField.textField.text)
        }
    }
    
    @objc private func forgotPassword() {
        print(": => forgot password clicked")
        navigation?.didTapForgotPassword()
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
    
    
//MARK: - Private methods
    private func setupKeyboardHiding(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            customRGBColor(red: 0, green: 171, blue: 187).cgColor,
            customRGBColor(red: 0, green: 171, blue: 187).cgColor
            
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds // Use bounds instead of frame
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    //MARK: - setup
    func setup() {
        let padding: CGFloat = 30
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(childContainerView)
        
        childContainerView.addSubview(blurView)
        childContainerView.addSubview(vStack)
        childContainerView.addSubview(forgotPasswordContainerView)
        forgotPasswordContainerView.addSubview(forgotPasswordBtn)
        
        containerView.addSubview(loginBtn)
        containerView.addSubview(createAccountBtn)
        
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        
        containerView.anchor(
            top: scrollView.contentLayoutGuide.topAnchor,
            left: scrollView.contentLayoutGuide.leftAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            right: scrollView.contentLayoutGuide.rightAnchor
        )
        //Without this containerView gets expanded horizontally which is bad
        containerView.centerX(inView: scrollView)
        
        iconImageView.centerX(
            inView: containerView,
            topAnchor: containerView.topAnchor,
            paddingTop: -30
        )
        iconImageView.setDimensions(height: 230, width: 230)
        
        titleLabel.centerX(
            inView: iconImageView,
            topAnchor: iconImageView.bottomAnchor,
            paddingTop: 0
        )
        
        childContainerView.anchor(
            top: titleLabel.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: 40,
            paddingLeft: 10,
            paddingRight: 10
        )
        
        childContainerView.setHeight(270)
        
        blurView.fillSuperview()
        blurView.effect = blurEffect
        childContainerView.sendSubviewToBack(blurView)
        
        vStack.anchor(
            top: childContainerView.topAnchor,
            left: childContainerView.leftAnchor,
            right: childContainerView.rightAnchor,
            paddingTop: 40,
            paddingLeft: padding,
            paddingRight: padding
        )
        
        forgotPasswordContainerView.centerX(
            inView: vStack,
            topAnchor: vStack.bottomAnchor,
            paddingTop: 20
        )
        forgotPasswordContainerView.setDimensions(height: 30, width: 200)
        
        forgotPasswordBtn.center(inView: forgotPasswordContainerView)
        
        loginBtn.centerX(
            inView: childContainerView,
            topAnchor: childContainerView.bottomAnchor,
            paddingTop: -24
        )
        loginBtn.anchor(
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingLeft: 40,
            paddingRight: 40
        )
        
        createAccountBtn.centerX(
            inView: loginBtn,
            topAnchor: loginBtn.bottomAnchor,
            paddingTop: 40
        )
        createAccountBtn.anchor(
            bottom: containerView.bottomAnchor
        )
        
    }

}

extension LoginViewController: AuthTextFieldDelegate {
    func textFieldShouldReturn(_ textField: AuthTextField) -> Bool {
        if textField == emailTextField {
            textField.textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        } else {
            textField.textField.resignFirstResponder()
            login()
        }
        return false
    }
}
