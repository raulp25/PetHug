//
//  ForgotPasswordViewController.swift
//  pethug
//
//  Created by Raul Pena on 17/10/23.
//

import Combine
import UIKit
import SwiftUI

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - Private components
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
    
    private let emailTextField = AuthTextField(
        viewModel: .init(
            type: .email,
            placeholderOption: .custom("Correo electronico"),
            returnKey: .continue,
            color: .white
        )
    )
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.text = "Enviaremos un link de recupación de contraseña a tu correo electrónico"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 244, green: 244, blue: 244, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var sendEmailBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Restablecer contraseña"))
        btn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    //MARK: - Private properties
    private let viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel(authService: AuthService())
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Internal properties
    weak var coordinator: ForgotPasswordCoordinator?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupKeyboardHiding()
        hideKeyboardWhenTappedAround()
        setup()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Bind
    func bind() {
        viewModel.state
            .handleThreadsOperator()
            .sink { [weak self] currentState in
                guard let self else { return }
                switch currentState {
                case .loading:
                    self.sendEmailBtn.isLoading = true
                case .success:
                    self.sendEmailBtn.isLoading = false
                    navigationController?.popViewController(animated: true)
                    coordinator?.parentCoordinator?.controllerDidSendResetPasswordLink()
                case .error(_):
                    self.handleError(message: "Algo salió mal, comprueba tu correo electrónico e intenta de nuevo", title: "Error")
                case .networkError:
                    self.handleError(message: "Sin conexion a internet, verifica tu conexion", title: "Sin conexión")
                }
            }.store(in: &subscriptions)
    }
    
    
    //MARK: - Actions
    @objc func resetPassword() {
        guard let email = emailTextField.isValidText() else { return }
        
        Task {
            await viewModel.resetPasswordWith(email: email)
        }
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
    
    private func handleError(message: String, title: String = ""){
        sendEmailBtn.isLoading = false
        alert(message: message, title: title)
    }
    
    //MARK: - setup
    private func setup() {
        emailTextField.delegate = self
       
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(captionLabel)
        view.addSubview(sendEmailBtn)
        
        titleLabel.centerX(
            inView: view,
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 20
        )
        
        captionLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 25,
            paddingLeft: 60,
            paddingRight: 60
        )
        
        
        emailTextField.anchor(
            top: captionLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 40,
            paddingLeft: 40,
            paddingRight: 40
        )
        
        sendEmailBtn.anchor(
            top: emailTextField.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 35,
            paddingLeft: 60,
            paddingRight: 60
        )
        
    }

}

extension ForgotPasswordViewController: AuthTextFieldDelegate {
    func textFieldShouldReturn(_ textField: AuthTextField) -> Bool {
        if textField == emailTextField {
            resetPassword()
            textField.textField.resignFirstResponder()
        }
        return true
    }
}


struct ForgotPasswordRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ForgotPasswordViewController {
        ForgotPasswordViewController()
    }
    
    func updateUIViewController(_ uiViewController: ForgotPasswordViewController, context: Context) {
        
    }
    
typealias UIViewControllerType = ForgotPasswordViewController

}

struct ViewController_Previews2: PreviewProvider {
    static var previews: some View {
        ForgotPasswordRepresentable()
    }
}


