//
//  PetsViewHeader.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit

protocol PetsViewHeaderDelegate: AnyObject {
    func didTapFilter()
    func didTapIcon()
}

final class PetsViewHeaderViewController: UIViewController {
    //MARK: - Private components
    lazy var logoContainerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChevron))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
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
        label.text = "Animales"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy var filterContainerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFilter))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private lazy var filterImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFilter))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    //MARK: - Private properties
    weak var delegate: PetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private actions    
    @objc private func didTapChevron() {
        delegate?.didTapIcon()
    }
    
    @objc private func didTapFilter() {
        delegate?.didTapFilter()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 20
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(filterContainerView)
        filterContainerView.addSubview(filterImageView)
        
        logoContainerView.centerY(
            inView: titleLabel,
            leftAnchor: view.leftAnchor,
            paddingLeft: sidePadding
        )
        logoContainerView.setDimensions(height: 35, width: 45)
        
        logoImageView.center(
            inView: logoContainerView
        )
        logoImageView.setDimensions(height: 20, width: 20)
        
        titleLabel.centerX(
            inView: view,
            topAnchor: view.topAnchor,
            paddingTop: paddingTop
        )
        
        filterContainerView.centerY(
            inView: titleLabel
        )
        filterContainerView.anchor(
            right: view.rightAnchor,
            paddingRight: sidePadding
        )
        filterContainerView.setDimensions(height: 40, width: 40)
        
        filterImageView.center(
            inView: filterContainerView
        )
        filterImageView.setDimensions(height: 30, width: 30)
    }
    
}
