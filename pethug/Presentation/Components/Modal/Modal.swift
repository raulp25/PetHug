//
//  Modal.swift
//  pethug
//
//  Created by Raul Pena on 21/10/23.
//

import UIKit

class Modal: UIView {
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Eliminar cuenta"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.text = "Su cuenta sera elminada de manera permanente e irreversible. Se perderán todos los datos asociados a la cuenta"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("First Button", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 34, green: 186, blue: 32)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didTapFirstButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var rightBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Second Button", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = customRGBColor(red: 186, green: 32, blue: 32)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didTapSecondButton), for: .touchUpInside)
        return btn
    }()
    
    private var leftButtonAction:  (() -> Void)?  = nil
    private var rightButtonAction: (() -> Void)?  = nil
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(
        leftButtonAction:  (() -> Void)?  = nil,
        rightButtonAction: (() -> Void)?  = nil,
        leftButtonTitle: String? = "First Button",
        rightButtonTitle: String? = "Second Button"
    ) {
        self.init(frame: .zero)
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.leftBtn.setTitle(leftButtonTitle, for: .normal)
        self.rightBtn.setTitle(rightButtonTitle, for: .normal)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setup() {
        backgroundColor = customRGBColor(red: 247, green: 247, blue: 247)
        
        addSubview(titleLabel)
        addSubview(captionLabel)
        addSubview(leftBtn)
        addSubview(rightBtn)
        
        titleLabel.centerX(
            inView: self,
            topAnchor: topAnchor,
            paddingTop: 15
        )
        
        captionLabel.centerX(
            inView: titleLabel,
            topAnchor: titleLabel.bottomAnchor,
            paddingTop: 20
        )
        
        captionLabel.anchor(
            left: leftAnchor,
            right: rightAnchor,
            paddingLeft: 25,
            paddingRight: 25
        )
        
        rightBtn.anchor(
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingBottom: 7,
            paddingRight: 5
        )
        rightBtn.setDimensions(height: 30, width: 100)
        
        leftBtn.anchor(
            bottom: bottomAnchor,
            right: rightBtn.leftAnchor,
            paddingBottom: 7,
            paddingRight: 10
        )
        leftBtn.setDimensions(height: 30, width: 100)
    }
    
    //MARK: - Private Actions
    @objc private func didTapScreen() {
        guard leftButtonAction != nil else { return }
        leftButtonAction!()
    }
    
    @objc private func didTapFirstButton() {
        guard leftButtonAction != nil else { return }
        leftButtonAction!()
    }
    
    @objc private func didTapSecondButton() {
        guard rightButtonAction != nil else { return }
        rightButtonAction!()
    }
    
    
}
