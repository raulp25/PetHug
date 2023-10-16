//
//  AnimalsStackContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

final class AnimalsStackContentViewController: UIViewController {
    //MARK: - Private components
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Inicio"
        label.font = UIFont.systemFont(ofSize: 55, weight: .light, width: .expanded)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var dogsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "perros", imageNamed: "banner6", textAlign: .left)
        return uv
    }()
    private lazy var catsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "gatos", imageNamed: "cats9", textAlign: .right)
        return uv
    }()
    private lazy var birdsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "pajaros", imageNamed: "birds2", textAlign: .left)
        return uv
    }()
    private lazy var rabbitsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "conejos", imageNamed: "rabbit1", textAlign: .right)
        return uv
    }()
    
    //MARK: - Private properties
    weak var delegate: PetsViewHeaderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapFilter() {
        delegate?.didTapFilter()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(dogsBanner)
        view.addSubview(catsBanner)
        view.addSubview(birdsBanner)
        view.addSubview(rabbitsBanner)

        titleLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingLeft: 30
        )

        dogsBanner.anchor(
            top: titleLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 30,
            paddingLeft: 20,
            paddingRight: 20
        )
        dogsBanner.setHeight(120)
        
        catsBanner.anchor(
            top: dogsBanner.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 20,
            paddingLeft: 20,
            paddingRight: 20
        )
        catsBanner.setHeight(120)
        
        birdsBanner.anchor(
            top: catsBanner.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 20,
            paddingLeft: 20,
            paddingRight: 20
        )
        birdsBanner.setHeight(120)
        
        rabbitsBanner.anchor(
            top: birdsBanner.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 20,
            paddingLeft: 20,
            paddingRight: 20
        )
        rabbitsBanner.setHeight(120)
        
    }
    
}
