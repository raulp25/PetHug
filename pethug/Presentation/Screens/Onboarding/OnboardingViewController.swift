//
//  OnboardingViewController.swift
//  pethug
//
//  Created by Raul Pena on 22/10/23.
//

import UIKit

final class OnboardingContentViewController: UIViewController {
    
    //MARK: - Private components
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(withAutolayout: true)
        sv.isDirectionalLockEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        sv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        return sv
    }()
    
    private let containerView: UIView = {
       let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    lazy private var mainImageView: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.image = UIImage(named: "pethug3")
        iv.tintColor = customRGBColor(red: 237, green: 237, blue: 237)
        iv.image?.withTintColor(.red)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    private lazy var adoptImageTextBox: ImageTextBox = {
        let it = ImageTextBox(title: "Adopta",
                              caption: "Salva a una mascota y hazla parte de tu familia adoptandola",
                              systemImage: "heart.fill")
        return it
    }()
    
    private lazy var postImageTextBox: ImageTextBox = {
        let it = ImageTextBox(title: "Publica",
                              caption: "Tienes una mascota en adopción? Publícala!",
                              systemImage: "hand.point.up.braille")
        return it
    }()
    
    private lazy var saveImageTextBox: ImageTextBox = {
        let it = ImageTextBox(title: "Salva a un amigo",
                              caption: "Ayudemos a quienes más lo necesitan. Di no a la compra",
                              systemImage: "megaphone")
        return it
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "General"
        label.font = UIFont.systemFont(ofSize: 50, weight: .light, width: .expanded)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Empezar", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 0, green: 171, blue: 187)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        return btn
    }()
    
    private let showOnboardingKey = OnboardingKey.showOnboarding.rawValue
    
    //MARK: - Internal properties
    weak var coordinator: LoginCoordinator?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setup()
    }
    
    //MARK: - Private actions
    @objc private func didTapStart() {
        UserDefaults.standard.set(true, forKey: showOnboardingKey)
        dismiss(animated: true)
    }
    
    //MARK: - Setup
    private func setup() {
        let sidePadding: CGFloat = 60
        let paddingTop: CGFloat = 30
        
        view.backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(mainImageView)
        containerView.addSubview(adoptImageTextBox)
        containerView.addSubview(postImageTextBox)
        containerView.addSubview(saveImageTextBox)
        containerView.addSubview(startButton)
        
        
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
        
        mainImageView.centerX(
            inView: containerView,
            topAnchor: containerView.topAnchor,
            paddingTop: 40
        )
        mainImageView.setDimensions(height: 300, width: 300)
        
        adoptImageTextBox.anchor(
            top: mainImageView.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: 40,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        adoptImageTextBox.setHeight(60)

        postImageTextBox.anchor(
            top: adoptImageTextBox.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: paddingTop,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        postImageTextBox.setHeight(60)
        
        saveImageTextBox.anchor(
            top: postImageTextBox.bottomAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: paddingTop,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        saveImageTextBox.setHeight(60)
        
        startButton.centerX(
            inView: containerView,
            topAnchor: saveImageTextBox.bottomAnchor,
            paddingTop: 60
        )
        startButton.anchor(
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingLeft: sidePadding,
            paddingRight: sidePadding
        )
        startButton.setHeight(50)
    }

    
}




