//
//  AnimalsStackContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

final class AnimalsStackContentViewController: UIViewController {
    //MARK: - Private components
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(withAutolayout: true)
        sv.isDirectionalLockEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return sv
    }()
    
    private let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Inicio"
        label.font = UIFont.systemFont(ofSize: 55, weight: .light, width: .expanded)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let dogsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "perros", imageNamed: "banner6", textAlign: .left)
        return uv
    }()
    private let catsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "gatos", imageNamed: "cats9", textAlign: .right)
        return uv
    }()
    private let birdsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "pajaros", imageNamed: "birds2", textAlign: .left)
        return uv
    }()
    private let rabbitsBanner: Banner = {
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
        let paddingTop: CGFloat = 20
        let sidePadding: CGFloat = 20
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dogsBanner)
        containerView.addSubview(catsBanner)
        containerView.addSubview(birdsBanner)
        containerView.addSubview(rabbitsBanner)
        
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        
        containerView.anchor(
            top: scrollView.contentLayoutGuide.topAnchor,
            left: scrollView.contentLayoutGuide.leftAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            right: scrollView.contentLayoutGuide.rightAnchor
        )
        //Without this containerView gets expanded horizontally which is bad
        containerView.centerX(inView: scrollView)
        
        titleLabel.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingLeft: 30
        )
        
        dogsBanner.anchor(
            top: titleLabel.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: 10,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        dogsBanner.setHeight(120)
        
        catsBanner.anchor(
            top: dogsBanner.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: paddingTop,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        catsBanner.setHeight(120)
        
        birdsBanner.anchor(
            top: catsBanner.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: paddingTop,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        birdsBanner.setHeight(120)
        
        rabbitsBanner.anchor(
            top: birdsBanner.bottomAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingTop: paddingTop,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        rabbitsBanner.setHeight(120)
        
    }
    
}

