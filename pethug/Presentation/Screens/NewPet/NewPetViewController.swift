//
//  NewPetViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

final class NewPetViewController: UIViewController {
    
    // MARK: - Private components
    private lazy var contentVC =  NewPetContentViewController(
                                    viewModel: NewPetViewModel(
                                        imageService: ImageService(),
                                        createPetUseCase: CreatePet.composeCreatePetUC(),
                                        updatePetUseCase: UpdatePet.composeUpdatePetUC(),
                                        deletePetFromRepeatedCollectionUC: DeletePetFromRepeatedCollection.composeDeletePetFromRepeatedCollectionUC(),
                                        authService: AuthService(),
                                        pet: self.pet
                                   ))
    
    
    private lazy var xmarkImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapXmark))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var xmarkImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.backward")
        iv.tintColor = .black.withAlphaComponent(0.8)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapXmark))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Subir"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    // MARK: - Internal properties
    weak var coordinator: NewPetCoordinator?
    var pet: Pet?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        setup()
        setupDelegates()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    deinit {
        coordinator?.coordinatorDidFinish()
        print("✅ Deinit NewPetViewController")
    }
    
    //MARK: - Setup

    private func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 20
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(xmarkImageContainer)
        xmarkImageContainer.addSubview(xmarkImageView)
        view.addSubview(titleLabel)
        add(contentVC)
        
        xmarkImageContainer.centerY(
            inView: titleLabel,
            leftAnchor: view.leftAnchor,
            paddingLeft: sidePadding
        )
        xmarkImageContainer.setDimensions(height: 35, width: 45)
        
        xmarkImageView.center(
            inView: xmarkImageContainer
        )
        
        titleLabel.centerX(
            inView: view,
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: paddingTop
        )
        
        contentVC.view.anchor(
            top: xmarkImageContainer.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: 20
        )
    }
    
    private func setupDelegates() {
        contentVC.delegate = self
    }

    //MARK: - Actions
    @objc func didTapXmark() {
        dismiss(animated: true)
    }
    
}


extension NewPetViewController: NewPetContentDelegate {
    func didEndUploading() {
        Task {
            await coordinator?.parentCoordinator?.viewModel.fetchUserPets(resetPagination: true)
        }
    }
}
