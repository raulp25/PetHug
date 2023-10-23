//
//  EditGalleryImagePageSheetView.swift
//  pethug
//
//  Created by Raul Pena on 02/10/23.
//

import UIKit

protocol EditGalleryImagePageSheetDelegate: AnyObject {
    func didTapDelete(cell indexPath: IndexPath)
    func didTapEdit()
}

final class EditGalleryImagePageSheetView: UIViewController {
    
    //MARK: - Private components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Origen"
        label.font = UIFont.systemFont(ofSize: 17.3, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.74)
        return label
    }()
    
    private lazy var hStackContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hStackDelete])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = ((view.frame.width / 2) / 5) * 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var hStackDelete: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deleteImage, deleteLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDelete))
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tapGesture)
        return stack
    }()
    
    private let deleteImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "trash"))
        iv.backgroundColor = .clear
        iv.tintColor = .orange
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Eliminar"
        label.font = UIFont.systemFont(ofSize: 15.3, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.74)
        return label
    }()
    
    private lazy var hStackEdit: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editImage, editLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
        stack.isUserInteractionEnabled = true
        stack.addGestureRecognizer(tapGesture)
        return stack
    }()
    
    private let editImage: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "pencil.and.outline"))
        iv.backgroundColor = .clear
        iv.tintColor = .orange
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let editLabel: UILabel = {
        let label = UILabel()
        label.text = "Editar"
        label.font = UIFont.systemFont(ofSize: 15.3, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.74)
        return label
    }()
    
    //MARK: - Internal properties
    weak var delegate: EditGalleryImagePageSheetDelegate?
    var pageSheetHeight: CGFloat? = nil
    var cellIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    
    //MARK: - Private Actions
     @objc private func didTapDelete() {
         guard let cellIndexPath = cellIndexPath else { return }
         delegate?.didTapDelete(cell: cellIndexPath)
         dismiss(animated: true)
    }
    
     @objc private func didTapEdit() {
         delegate?.didTapEdit()
         dismiss(animated: true)
    }
    
    //MARK: - Private Methods
    private func configure() {
        let paddingTop = (pageSheetHeight ?? 0) / 3
        view.backgroundColor = .white
//        view.addSubview(titleLabel)
        view.addSubview(hStackContainer)
//
//        titleLabel.centerX(
//            inView: view,
//            topAnchor: view.topAnchor,
//            paddingTop: paddingTop
//        )
        
        hStackContainer.center(
            inView: view,
            yConstant: 0
        )
        
        deleteImage.setDimensions(height: 30, width: 30)
        
//        editImage.setDimensions(height: 30, width: 30)
        
    }
    
}

