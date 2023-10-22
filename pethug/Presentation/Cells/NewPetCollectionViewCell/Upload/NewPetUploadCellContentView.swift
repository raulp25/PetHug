//
//  NewPetUploadCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit
import Combine

final class NewPetUploadCellContentView: UIView, UIContentView {
    //MARK: - Private components
    private let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Nombre del animal / Título"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var uploadBtn: AuthButton = {
        let btn = AuthButton(viewModel: .init(title: "Subir"))
        btn.backgroundColor = customRGBColor(red: 255, green: 176, blue: 42)
        btn.addTarget(self, action: #selector(upload), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Properties
    private var currentConfiguration: NewPetUploadListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetUploadListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    init(configuration: NewPetUploadListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()
        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private actions
    @objc private func upload() {
        print(":clicked upload button => ")
        currentConfiguration.viewModel?.delegate?.didTapUpload()
    }
    
    
    // MARK: - Functions
    private func apply(configuration: NewPetUploadListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        guard let item = currentConfiguration.viewModel else { return }
        uploadBtn.setTitle(item.buttonText, for: .normal)
        uploadBtn.backgroundColor = customRGBColor(red: 255, green: 176, blue: 42)
        
        item.isFormValid?
            .handleThreadsOperator()
            .sink(receiveValue: { [weak self] isValid in
                self?.uploadBtn.backgroundColor = isValid ?
                customRGBColor(red: 255, green: 176, blue: 42) :
                customRGBColor(red: 250, green: 219, blue: 165, alpha: 1)
                
                self?.uploadBtn.isEnabled = isValid
            }).store(in: &cancellables)
        
        item.state?
            .handleThreadsOperator()
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .loading:
                    self?.uploadBtn.isLoading = true
                case .success:
                    self?.uploadBtn.isLoading = false
                case .error(let error):
                    self?.uploadBtn.isLoading = false
                    print("error uploading pet: => \(error.localizedDescription)")
                case .networkError:
                    self?.uploadBtn.isLoading = false
                    print("error network connection: => ")
                }
            }).store(in: &cancellables)
    }
    
    

    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        addSubview(containerView)
        containerView.addSubview(uploadBtn)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10)
        containerView.setHeight(45)
        
        uploadBtn.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
    }


}


