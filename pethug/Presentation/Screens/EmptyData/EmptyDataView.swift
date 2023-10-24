//
//  EmptyDataView.swift
//  pethug
//
//  Created by Raul Pena on 22/10/23.
//

import UIKit

final class EmptyDataView: UIViewController {
    //MARK: - Private components
    private lazy var iconView: UIImageView = {
       let iv = UIImageView(withAutolayout: true)
        iv.image = UIImage(systemName: "triangle")
        iv.tintColor = .black.withAlphaComponent(0.8)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mascotas"
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Aún no hay mascotas en los resultados"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Private properties
    private var titleTxt: String?
    private var caption: String?
    private var namedImage: String?
    private var systemImage: String?
    
    //MARK: - LifeCycle
    init(
        title: String? = nil,
        caption: String? = nil,
        namedImage: String? = nil,
        systemImage: String? = nil
    ) {
        self.titleTxt  = title
        self.caption   = caption
        self.namedImage  = namedImage
        self.systemImage  = systemImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Setup
    func setup() {
        let width = CGFloat(200)
        
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(captionLabel)
        
        iconView.center(
            inView: view,
            yConstant: -100
        )
        iconView.setDimensions(height: 100, width: 100)
        
        titleLabel.centerX(
            inView: iconView,
            topAnchor: iconView.bottomAnchor,
            paddingTop: 0
        )
        titleLabel.setWidth(width)
        
        captionLabel.centerX(
            inView: titleLabel,
            topAnchor: titleLabel.bottomAnchor,
            paddingTop: 5
        )
        captionLabel.setWidth(width)
        
        if let title = titleTxt {
            titleLabel.text = title
        }
        
        if let caption = caption {
            captionLabel.text = caption
        }
        
        if let namedImage = namedImage {
            iconView.image = UIImage(named: namedImage)
        }
        
        if let systemImage = systemImage {
            iconView.image = UIImage(systemName: systemImage)
        }
        
    }
}

