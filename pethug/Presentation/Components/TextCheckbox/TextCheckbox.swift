//
//  TextCheckbox.swift
//  pethug
//
//  Created by Raul Pena on 08/10/23.
//

import UIKit

final class TextCheckbox: UIView {
    
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textLabel, checkMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Pequeńo"
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var checkMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    convenience init(titleText: String, isChecked: Bool) {
        self.init(frame: .zero)
        configureUI(titleText: titleText, isChecked: isChecked)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI(titleText: String, isChecked: Bool) {
        textLabel.text = titleText
        
        if isChecked {
            checkMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            checkMarkButton.tintColor = .systemOrange
        }  else {
            checkMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
            checkMarkButton.tintColor = .black
        }
    }
    
    
    func configureConstraints() {
        addSubview(hStack)
        hStack.fillSuperview()
    }
    
}

