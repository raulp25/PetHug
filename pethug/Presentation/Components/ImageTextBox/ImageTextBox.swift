//
//  ImageTextBox.swift
//  pethug
//
//  Created by Raul Pena on 22/10/23.
//

import UIKit

final class ImageTextBox: UIView {
    //MARK: - Private components
    private lazy var imageView: UIImageView = {
       let iv = UIImageView()
        iv.tintColor =  customRGBColor(red: 0, green: 171, blue: 187)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.text = "Caption"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Private properties
    private var alignment: ImageTextBox.TextAlign!
    private var namedImage: String?
    private var systemImage: String?
    private var height: CGFloat?
    private var width:  CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(
        title:      String,
        caption:    String,
        namedImage: String? = nil,
        systemImage: String? = nil,
        textAlign: ImageTextBox.TextAlign = .left,
        height:    CGFloat? = nil,
        width:     CGFloat? = nil
    ) {
        self.init(frame: .zero)
        
        self.titleLabel.text = title
        self.captionLabel.text = caption
        self.namedImage = namedImage
        self.systemImage = systemImage
        self.alignment = textAlign
        self.height = height
        self.width = width
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private actions
    
    //MARK: - Setup
    func setup() {
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(captionLabel)

        imageView.centerY(
            inView: self,
            leftAnchor: leftAnchor
        )
        imageView.setDimensions(height: height ?? 60, width: width ?? 60)
//        imageView.layer.borderColor = UIColor.green.cgColor
//        imageView.layer.borderWidth = 2
        
        titleLabel.anchor(
            top: topAnchor,
            left: imageView.rightAnchor,
            right: rightAnchor,
            paddingLeft: 15
        )
        
        captionLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: imageView.rightAnchor,
            right: rightAnchor,
            paddingLeft: 15
        )
        
        
        if let namedImage = namedImage {
            imageView.image = UIImage(named: namedImage)
        }
        
        if let systemImage = systemImage {
            imageView.image = UIImage(systemName: systemImage)
        }
    }
    
}


extension ImageTextBox {
    enum TextAlign {
        case left
        case right
    }
}

