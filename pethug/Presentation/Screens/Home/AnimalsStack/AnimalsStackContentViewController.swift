//
//  AnimalsStackContentViewController.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

protocol AnimalsStackNavigatable: AnyObject {
    func didTapAllPetsBanner()
    func didTapDogsBanner()
    func didTapCatsBanner()
    func didTapBirdsBanner()
    func didTapRabbitsBanner()
}

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
        label.font = UIFont.systemFont(ofSize: 65, weight: .light, width: .compressed)
        label.textColor = customRGBColor(red: 18, green: 89, blue: 103)
        return label
    }()
    
    private lazy var allPetsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "todos", imageNamed: "all", textAlign: .left)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBanner))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        uv.tag = 1
        return uv
    }()
    
    private lazy var dogsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "perros", imageNamed: "dogs12", textAlign: .right)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBanner))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        uv.tag = 2
        return uv
    }()
    private lazy var catsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "gatos", imageNamed: "cats9", textAlign: .left)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBanner))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        uv.tag = 3
        return uv
    }()
    private lazy var birdsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "pajaros", imageNamed: "birds2", textAlign: .right)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBanner))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        uv.tag = 4
        return uv
    }()
    private lazy var rabbitsBanner: Banner = {
        let uv = Banner(title: "Adopta", caption: "conejos", imageNamed: "rabbit1", textAlign: .left)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBanner))
        uv.isUserInteractionEnabled = true
        uv.addGestureRecognizer(tapGesture)
        uv.tag = 5
        return uv
    }()
    
    //MARK: - Private properties
    weak var delegate: AnimalsStackNavigatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapBanner(_ sender: UITapGestureRecognizer) {
        if let banner = sender.view as? Banner {
            switch banner.tag {
            case 1:
                delegate?.didTapAllPetsBanner()
            case 2:
                delegate?.didTapDogsBanner()
            case 3:
                delegate?.didTapCatsBanner()
            case 4:
                delegate?.didTapBirdsBanner()
            case 5:
                delegate?.didTapRabbitsBanner()
            default:
                print("")
            }
            
        }
//        delegate?.didTapFilter()
    }
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 20
        let sidePadding: CGFloat = 20
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = customRGBColor(red: 248, green: 248, blue: 248)
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
//        containerView.addSubview(titleLabel)
        containerView.addSubview(allPetsBanner)
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
//
//        titleLabel.anchor(
//            top: containerView.topAnchor,
//            left: containerView.leftAnchor,
//            right: containerView.rightAnchor,
//            paddingLeft: 30
//        )
        
//        titleLabel.centerX(inView: containerView, topAnchor: containerView.topAnchor, paddingTop: 10)
        
        allPetsBanner.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: 50,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        allPetsBanner.setHeight(120)
        
        dogsBanner.anchor(
            top: allPetsBanner.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: paddingTop,
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

