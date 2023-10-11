//
//  NewPetViewController.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

final class NewPetViewController: UIViewController {
    
    // MARK: - Private components
    private lazy var contentVC: NewPetContentViewController = {
        let vc =  NewPetContentViewController(
                    viewModel: NewPetViewModel(
                        imageService: ImageService(),
                        createPetUseCase: CreatePet.composeCreatePetUC(),
                        updatePetUseCase: UpdatePet.composeUpdatePetUC(),
                        deletePetFromRepeatedCollectionUC: DeletePetFromRepeatedCollection.composeDeletePetFromRepeatedCollectionUC(),
                        pet: self.pet
                   ))
        vc.delegate = self
        return vc
    }()
    
    private lazy var xmarkImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapXmark))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var xmarkImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "xmark")
//      iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.tintColor = .systemPink
        iv.contentMode = .scaleAspectFit
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
    //    init(viewModel: NewMessageViewModel) {
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = customRGBColor(red: 58, green: 91, blue: 144)
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(xmarkImageContainer)
        xmarkImageContainer.addSubview(xmarkImageView)
        view.addSubview(titleLabel)
        add(contentVC)

        titleLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        
        xmarkImageContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 15)
        xmarkImageContainer.setDimensions(height: 30, width: 30)
        
        xmarkImageView.center(inView: xmarkImageContainer)
        
        contentVC.view.anchor(top: xmarkImageContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
        
    }
    
    
    //MARK: - Actions
    @objc func didTapXmark() {
        print("clicked xmark: => ")
        dismiss(animated: true)
    }
    
}


extension NewPetViewController: NewPetContentDelegate {
    func didEndUploading() {
        coordinator?.parentCoordinator?.viewModel.fetchUserPets(resetPagination: true)
    }
}
