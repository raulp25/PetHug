//
//  NewPetGenderCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit


final class NewPetGenderCellContentView: UIView, UIContentView {
    
    //MARK: - Private components
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Genero (No obligatorio)"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [hStackMale, hStackFemale])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        //        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private lazy var hStackMale: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [maleLabel, maleCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        //        stack.spacing = 15
        //        stack.layoutMargins = .init(top: 10, left: 20, bottom: 10, right: 20)
        //        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //    checkmark.square
    private let maleLabel: UILabel = {
        let label = UILabel()
        label.text = "Macho"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    lazy private var maleCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        //        button.tag = CurrentChecked.dog.rawValue
        return button
    }()
    
    private lazy var hStackFemale: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [femaleLabel, femaleCheckMarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        //        stack.spacing = 15
        //        stack.layoutMargins = .init(top: 10, left: 20, bottom: 10, right: 20)
        //        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hembra"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    lazy private var femaleCheckMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCheckMark), for: .touchUpInside)
        //        button.tag = CurrentChecked.cat.rawValue
        return button
    }()
    
    //MARK: - Private properties
    
    
    //MARK: - Internal properties
    
    // MARK: - Properties
    private var currentConfiguration: NewPetGenderListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetGenderListCellConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    let containerView = UIView()
    
    // MARK: - LifeCycle
    init(configuration: NewPetGenderListCellConfiguration) {
        super.init(frame: .zero)
        buttons = [maleCheckMarkButton, femaleCheckMarkButton]
        for (index, button) in buttons.enumerated() {
            button.tag = index + 1
        }
        // create the content view UI
        setup()
        
        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
        
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("✅ Deinit NewPetGalleryContentView")
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetGenderListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        //
        guard let item = currentConfiguration.viewModel else { return }
        //        nameLabel.text = item.name
        //        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        //        nameLabel.textColor = UIColor.blue.withAlphaComponent(0.7)
        //
        //        imageView.configure(with: item.profileImageUrlString)
    }
    
    private func setup() {
        let height = CGFloat(30)
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        
        addSubview(titleLabel)
        addSubview(vStack)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        titleLabel.setHeight(16)
        
        vStack.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 20)
        vStack.setHeight(75)
        
        for button in buttons {
            button.setHeight(height)
        }
    }
    
    
    //    enum CurrentChecked: String {
    //        case dog
    //        case cat
    //        case bird
    //        case rabbit
    //
    //    }
    //    var currentButton: CurrentChecked? = nil
    
    //    @objc func didTapCheckMark(_ sender: UIButton) {
    //        if sender == dogCheckMarkButton && currentButton == .dog {
    //           sender.setImage(UIImage(systemName: "square"), for: .normal)
    //           sender.tintColor = .black
    //        } else if sender == dogCheckMarkButton {
    //            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    //            sender.tintColor = .systemOrange
    //            currentButton = .dog
    //        } else {
    //            dogCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //            dogCheckMarkButton.tintColor = .black
    //        }
    //
    //        if sender == catCheckMarkButton && currentButton == .cat {
    //           sender.setImage(UIImage(systemName: "square"), for: .normal)
    //           sender.tintColor = .black
    //        } else if sender == catCheckMarkButton {
    //            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    //            sender.tintColor = .systemOrange
    //            currentButton = .cat
    //        } else {
    //            catCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //            catCheckMarkButton.tintColor = .black
    //        }
    //
    //        if sender == birdCheckMarkButton && currentButton == .bird {
    //           sender.setImage(UIImage(systemName: "square"), for: .normal)
    //           sender.tintColor = .black
    //        } else if sender == birdCheckMarkButton {
    //            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    //            sender.tintColor = .systemOrange
    //            currentButton = .bird
    //        } else {
    //            birdCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //            birdCheckMarkButton.tintColor = .black
    //        }
    //
    //        if sender == rabbitCheckMarkButton && currentButton == .rabbit {
    //           sender.setImage(UIImage(systemName: "square"), for: .normal)
    //           sender.tintColor = .black
    //        } else if sender == rabbitCheckMarkButton {
    //            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    //            sender.tintColor = .systemOrange
    //            currentButton = .rabbit
    //        } else {
    //            rabbitCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //            rabbitCheckMarkButton.tintColor = .black
    //        }
    //    }
    
    enum CurrentChecked: Int {
        case dog = 1
        case cat = 2
        case bird = 3
        case rabbit = 4
    }
    
    var currentButton: CurrentChecked? = nil
    var buttons: [UIButton] = []
    //    @objc func didTapCheckMark(_ sender: UIButton) {
    //        print("sender tag: => \(sender.tag)")
    //        print("CurrentChecked(rawValue: sender.tag) : => \(CurrentChecked(rawValue: sender.tag) )")
    //        guard let checked = CurrentChecked(rawValue: sender.tag) else {
    //            return
    //        }
    //
    //        // Reset all buttons to "square"
    //        dogCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //        catCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //        birdCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //        rabbitCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
    //
    //        // Reset all buttons to black color
    //        dogCheckMarkButton.tintColor = .black
    //        catCheckMarkButton.tintColor = .black
    //        birdCheckMarkButton.tintColor = .black
    //        rabbitCheckMarkButton.tintColor = .black
    //
    ////        if checked == currentButton {
    ////            sender.setImage(UIImage(systemName: "square"), for: .normal)
    ////            sender.tintColor = .black
    ////            currentButton = nil
    ////        } else {
    //            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    //            sender.tintColor = .systemOrange
    //            currentButton = checked
    ////        }
    //    }
    
    @objc func didTapCheckMark(_ sender: UIButton) {
        guard let checked = CurrentChecked(rawValue: sender.tag) else {
            return
        }
        
//        for button in buttons {
//            if button == sender {
//                button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//                button.tintColor = .systemOrange
//            } else {
//                button.setImage(UIImage(systemName: "square"), for: .normal)
//                button.tintColor = .black
//            }
//        }
//
//        if checked == currentButton {
//            sender.setImage(UIImage(systemName: "square"), for: .normal)
//            sender.tintColor = .black
//            currentButton = nil
//        } else {
//            currentButton = checked
//        }
        
        for button in buttons {
            if button == sender {
                if checked == currentButton {
                    button.setImage(UIImage(systemName: "square"), for: .normal)
                    button.tintColor = .black
                    currentButton = nil
                } else {
                    button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    button.tintColor = .systemOrange
                    currentButton = checked
                }
            } else {
                button.setImage(UIImage(systemName: "square"), for: .normal)
                button.tintColor = .black
            }
        }
    }
}

