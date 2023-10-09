//
//  FilterPetsViewHeaderViewController.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

protocol FilterPetsViewHeaderDelegate: AnyObject {
    func didTapIcon()
}

final class FilterPetsViewHeaderViewController: UIViewController {
    //MARK: - Private components
    private lazy var logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.backward")
        iv.tintColor = .black.withAlphaComponent(0.8)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChevron))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "FILTROS DE BÚSQUEDA"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    
    //MARK: - Private properties
    weak var delegate: FilterPetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapChevron() {
        delegate?.didTapIcon()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 3
        let sidePadding: CGFloat = 25
        view.backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        
        logoImageView.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: sidePadding)
        logoImageView.setDimensions(height: 20, width: 20)
        
        titleLabel.center(inView: view)
        
    }
    
}

