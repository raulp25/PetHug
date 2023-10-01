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
    private let childContainerView = UIView(withAutolayout: true)
    
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
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 25
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
            placeholderOption: .custom("Email"),
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
    
    private lazy var createAccountBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Create account"))
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
    private var keyboardPublisher: AnyCancellable?
    
    private var flowLayoutConstraint: NSLayoutConstraint!
    
    //MARK: - Internal properties
    weak var coordinator: CreateAccountCoordinator?
    
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
                    self.createAccountBtn.isLoading = true
                case .success:
                    self.createAccountBtn.isLoading = false
                case let.error(err):
                    self.createAccountBtn.isLoading = false
                    self.alert(message: err.localizedDescription, title: "Error")
                }
            }.store(in: &subscriptions)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundImageView.removeFromSuperview()
        keyboardPublisher = nil
        keyboardPublisher?.cancel()
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
        let sidePadding: CGFloat = 50
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        view.addSubview(containerView)
        containerView.addSubview(plusPhotoImageView)
        containerView.addSubview(childContainerView)

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
        childContainerView.addSubview(createAccountBtn)
        
        childContainerView.anchor(
            top: plusPhotoImageView.bottomAnchor,
            left: containerView.leftAnchor,
            bottom: view.bottomAnchor,
            right: containerView.rightAnchor,
            paddingTop: CGFloat(Int(paddintTop))
        )
        
        childContainerView.layer.cornerRadius = 30
        childContainerView.backgroundColor = .white
        
        titleLabel.anchor(
            top: childContainerView.topAnchor,
            left: childContainerView.leftAnchor,
            paddingTop: 30,
            paddingLeft: sidePadding
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
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
       
        createAccountBtn.anchor(
            top: vStack.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
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
        
        print("current textfield in textfieldShouldreturn(): => \(textField)")
        print("textField === usernameTextField: => \(textField === usernameTextField)")
        
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
        return true
    }
}


