//
//  TextCheckbox.swift
//  pethug
//
//  Created by Raul Pena on 08/10/23.
//

import UIKit

protocol TextCheckBoxDelegate: AnyObject {
    func didTapCheckBox()
}

final class TextCheckbox: UIView {
    //MARK: - Private components
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
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    //MARK: - Private properties
    private var font: UIFont?
    private var isClickable: Bool = false
    private weak var delegate: TextCheckBoxDelegate?
    
    //MARK: - Internal properties
    var isChecked = false {
        didSet {
            updateCheckmarkUI()
        }
    }
    
    //MARK: - LifeCycle
    convenience init(
        titleText: String,
        isChecked: Bool,
        font: UIFont? = nil,
        isClickable: Bool = false,
        delegate: TextCheckBoxDelegate? = nil
    ) {
        self.init(frame: .zero)
        self.isChecked = isChecked
        self.isClickable = isClickable
        self.delegate = delegate
        configureUI(titleText: titleText, font: font)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func configureUI(titleText: String, font: UIFont?) {
        textLabel.text = titleText
        
        if let font = font {
            textLabel.font = font
        }
        
        updateCheckmarkUI()
    }
    
    
    private func configureConstraints() {
        addSubview(hStack)
        hStack.fillSuperview()
    }
    
    //MARK: - Private actions
    @objc private func didTapCheckMark(_ sender: UIButton) {
        guard isClickable else { return }
        isChecked = !isChecked
        delegate?.didTapCheckBox()
    }
    
    //MARK: - Private methods
    private func updateCheckmarkUI() {
        if isChecked {
            checkMarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            checkMarkButton.tintColor = .systemOrange
        } else {
            checkMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
            checkMarkButton.tintColor = .black
        }
    }
}

