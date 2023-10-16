//
//  Banner.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit

final class Banner: UIView {
    //MARK: - Private components
    lazy var containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        return uv
    }()
    
    private lazy var imageView: UIImageView = {
       let iv = UIImageView()
        iv.tintColor = customRGBColor(red: 55, green: 55, blue: 55)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var vStack: UIStackView = {
        let stack: UIStackView = .init(arrangedSubviews: [titleLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = true
        return stack
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Adoptar"
//        label.font = UIFont.systemFont(ofSize: 22, weight: .bold, width: .expanded)
        label.textColor = customRGBColor(red: 255, green: 255, blue: 255)
        
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        let attributedText = NSMutableAttributedString(string: "Adoptar")
        let letterSpacing: CGFloat = 2.5
        attributedText.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedText.length))
        label.attributedText = attributedText
        
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
//        label.text = "perros"
//        label.font = UIFont.systemFont(ofSize: 22, weight: .regular, width: .expanded)
        label.textColor = customRGBColor(red: 255, green: 255, blue: 255)
        
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        let attributedText = NSMutableAttributedString(string: "pajaros")
        let letterSpacing: CGFloat = 2.5
        attributedText.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedText.length))
        label.attributedText = attributedText
        
        
        return label
    }()
    private var alignment: Banner.TextAlign!
    
    //MARK: - Private properties
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    convenience init(title: String =  "", caption: String = "", imageNamed: String? = nil, textAlign: Banner.TextAlign = .right) {
        self.init(frame: .zero)
        
        self.titleLabel.text = title
        self.captionLabel.text = caption
        self.alignment = textAlign
        if let image = imageNamed {
            self.imageView.image = UIImage(named: image)
        }
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Private actions
    
    //MARK: - Setup
    func setup() {
        let paddingTop: CGFloat = 15
        let sidePadding: CGFloat = 25
        backgroundColor = customRGBColor(red: 245, green: 245, blue: 245)
        layer.cornerRadius = 8
        
        addSubview(imageView)
        addSubview(vStack)
        bringSubviewToFront(vStack)
        sendSubviewToBack(imageView)
        
        
        if self.alignment == .left {
            vStack.centerY(
                inView: self,
                leftAnchor: leftAnchor,
                paddingLeft: 25
            )
        } else {
            vStack.centerY(inView: self)
            vStack.anchor(
                right: rightAnchor,
                paddingRight: 25
            )
        }
        
        vStack.setHeight(55)
    
        imageView.fillSuperview()
        imageView.layer.cornerRadius = 8
    }
    
}


extension Banner {
    enum TextAlign {
        case left
        case right
    }
}
