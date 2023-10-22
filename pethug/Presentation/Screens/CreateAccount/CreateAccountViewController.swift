//
//  CreateAccountViewController.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import Combine
import UIKit
import SwiftUI

class CreateAccountViewController: UIViewController {
    
    //MARK: - Private components
    private let containerView: UIView = {
       let uv = UIView(withAutolayout: true)
        return uv
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
    
    private let createAccountLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Crear cuenta"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold, width: .condensed)
        return label
    }()
    
    private let childContainerView: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.backgroundColor = customRGBColor(red: 248, green: 247, blue: 245, alpha: 1)
        return uv
    }()
    
    private let formContainerView: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.layer.cornerRadius = 8
        
        uv.layer.shadowColor = customRGBColor(red: 200, green: 200, blue: 200, alpha: 0.8).cgColor
        uv.layer.shadowOpacity = 20
        uv.layer.shadowOffset = .zero
        uv.layer.shadowRadius = 7
        return uv
    }()
    
    let blurView: UIVisualEffectView = {
        let vv = UIVisualEffectView()
        vv.clipsToBounds = true
        vv.layer.cornerRadius = 7
        vv.translatesAutoresizingMaskIntoConstraints = false
        vv.backgroundColor = customRGBColor(red: 247, green: 247, blue: 247, alpha: 0.8)
       return vv
    }()
    
    let blurEffect  = UIBlurEffect(style: .systemUltraThinMaterial)
    
    private lazy var plusPhotoImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(systemName: "plus.circle"))
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfilePhotoSelect))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private let addPhotoLabel: UILabel = {
       let label = UILabel(withAutolayout: true)
        label.text = "Imagen de perfil"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let usernameTextField = AuthTextField(
        viewModel: .init(
            type: .name,
            placeholderOption: .custom("Nombre usuario"),
            returnKey: .continue
        )
    )
    
    private let emailTextField = AuthTextField(
        viewModel: .init(
            type: .email,
            placeholderOption: .custom("Correo electrónico"),
            returnKey: .continue
        )
    )
    
    
    private let passwordTextField = AuthTextField(
        viewModel: .init(
            type: .newAccountPassword,
            placeholderOption: .custom("Contraseña"),
            returnKey: .done
        )
    )
    
    private lazy var createAccountBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Crear cuenta"))
        btn.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return btn
    }()
    
    
    
    //MARK: - Private properties
    private var viewModel = CreateAccountViewModel(
                            authService: AuthService(),
                            imageService: ImageService(),
                            useCase: RegisterUser.composeRegisterUserUC()
                        )
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: - Internal properties
    weak var coordinator: CreateAccountCoordinator?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customRGBColor(red: 248, green: 111, blue: 14)
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
    private func bind() {
        viewModel.state
            .handleThreadsOperator()
            .sink { [weak self] currentState in
                guard let self else { return }
                switch currentState {
                case .loading:
                    self.createAccountBtn.isLoading = true
                case .success:
                    self.createAccountBtn.isLoading = false
                case let.error(err):
                    self.createAccountBtn.isLoading = false
                    self.alert(message: err.localizedDescription, title: "Error")
                }
            }.store(in: &subscriptions)
    }
    
    //MARK: - Actions
    @objc func handleProfilePhotoSelect() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    @objc func createAccount() {
        guard
            let validUsername = usernameTextField.isValidText(),
            let validEmail = emailTextField.isValidText(),
            let validPassword = passwordTextField.isValidText()  else {
            return
        }
        print("create account ()")
        Task {
            await viewModel.crateAccount(
                username: validUsername,
                email: validEmail,
                password: validPassword
            )
        }
        
    }
    
    @objc private func forgotPassword() {
        // TODO: Create forgot password flow after first release
        print(": => forgot password clicked")
    }
    
    @objc func goBackToLogin() {
//        coordinator?.startCreateAccountCoordinator()
    }
    
    //MARK: - Private Methods
    private func setupKeyboardHiding(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
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
        
        let intOne:CGFloat = 10, intTwo: CGFloat = 150

        if (textFieldBottomY + intOne) > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY + intTwo
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    //MARK: - setup
    func setup() {
        let paddintTop = UIScreen.main.bounds.height * 0.05
        let sidePadding: CGFloat = 20
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    
        
        view.addSubview(containerView)
        containerView.addSubview(childContainerView)
        
        childContainerView.addSubview(titleLabel)
        childContainerView.addSubview(formContainerView)
        
        formContainerView.addSubview(blurView)
        formContainerView.addSubview(addPhotoLabel)
        formContainerView.addSubview(createAccountLabel)
        formContainerView.addSubview(plusPhotoImageView)
        formContainerView.addSubview(vStack)
        formContainerView.addSubview(createAccountBtn)
        
        containerView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        
        
        childContainerView.anchor(
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingTop: 30,
            height: (UIScreen.main.bounds.height / 8) * 5
        )

        
        formContainerView.anchor(
            top: childContainerView.topAnchor,
            left: childContainerView.leftAnchor,
            right: childContainerView.rightAnchor,
            //Responsive for se 3rd gen
            paddingTop: UIScreen.main.bounds.size.height < 700 ? -120 : -100,
            paddingLeft: 35,
            paddingRight: 35,
            height: 560
        )
        
        blurView.fillSuperview()
        blurView.effect = blurEffect
        
        titleLabel.centerX(
            inView: formContainerView
        )
        titleLabel.anchor(
            bottom: formContainerView.topAnchor,
            //Responsive for se 3rd gen
            paddingBottom: UIScreen.main.bounds.size.height < 700 ? 10 : 50
        )
        
        createAccountLabel.centerX(
            inView: formContainerView,
            topAnchor: formContainerView.topAnchor,
            paddingTop: 20
        )
        
        addPhotoLabel.anchor(
            top: createAccountLabel.bottomAnchor,
            left: formContainerView.leftAnchor,
            paddingTop: 30,
            paddingLeft: sidePadding
        )
        
        plusPhotoImageView.anchor(
            top: addPhotoLabel.bottomAnchor,
            left: formContainerView.leftAnchor,
            paddingTop: 10,
            paddingLeft: sidePadding
        )
        plusPhotoImageView.setDimensions(height: 80, width: 80)
        
        vStack.anchor(
            top: plusPhotoImageView.bottomAnchor,
            left: formContainerView.leftAnchor,
            right: formContainerView.rightAnchor,
            paddingTop: 30,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
       
        createAccountBtn.anchor(
            top: vStack.bottomAnchor,
            left: formContainerView.leftAnchor,
            right: formContainerView.rightAnchor,
            paddingTop: 50,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
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
        
        self.dismiss(animated: true)
    }
    
}


extension CreateAccountViewController: AuthTextFieldDelegate {
    func textFieldShouldReturn(_ textField: AuthTextField) -> Bool {
        
        switch textField {
        case usernameTextField:
            textField.textField.resignFirstResponder()
            emailTextField.textField.becomeFirstResponder()
            
        case emailTextField:
            textField.textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
            
        default:
            // create account
            createAccount()
            textField.textField.resignFirstResponder()
        }
        return false
    }
}




struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CreateAccountViewController {
        CreateAccountViewController()
    }
    
    func updateUIViewController(_ uiViewController: CreateAccountViewController, context: Context) {
        
    }
    
typealias UIViewControllerType = CreateAccountViewController

}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}

