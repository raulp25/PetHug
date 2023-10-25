//
//  GradientButton.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//
import UIKit

class GradientUIViewButton: UIView {
    var title: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private var logoImage: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 25, width: 25)
        return iv
    }()
    
    var showLoader = false {
        didSet {
            configureActivityIndicator()
        }
    }
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    var startColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var endColor: UIColor? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var isEnabled = false {
        didSet {
            if isUserInteractionEnabled == false && isEnabled == true ||
                isUserInteractionEnabled == true && isEnabled == false {
                isUserInteractionEnabled = !isUserInteractionEnabled
            }
            
        }
    }
        
    // Create gradient layer
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        guard let startColor = startColor else { return }
        guard let endColor = endColor else { return }
        // Set the gradient frame
        gradientLayer.frame = rect
        
        // Set the colors
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        // Gradient is linear from left to right
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        
        // Add gradient layer into the button
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Round the button corners
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
    
    init(startColor: UIColor? = nil, endColor: UIColor? = nil) {
        self.startColor = startColor != nil ? startColor : .red
        self.endColor   = endColor   != nil ? endColor   : .yellow
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        title.center(inView: self)
    }
    
    
    func configureActivityIndicator() {
        if showLoader {
            removeViewsFromSuperView(views: [title, logoImage])
            
            self.addSubview(activityIndicatorView)
            activityIndicatorView.fillSuperview()
            activityIndicatorView.color = .white
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.removeFromSuperview()
            configureUI()
            
            if logoImage.image != nil {
                setImage(image: logoImage.image!, withDimensions: Dimensions(height: logoImage.frame.height, width: logoImage.frame.height))
            }
        }
    }
    
    func setImage(image: UIImage, withDimensions dimensions: Dimensions? = nil) {
        
        logoImage.image = image
        
        if dimensions != nil {
            guard let height = dimensions?.height else { return }
            guard let width = dimensions?.width else { return }
            
            logoImage.setDimensions(height: height, width: width)
        }
        
        addSubview(logoImage)
        logoImage.centerY(
            inView: title
        )
        logoImage.anchor(
            right: title.leftAnchor,
            paddingRight: 5
        )
    }
    
    func removeViewsFromSuperView(views: [UIView]) {
        views.forEach { view in
            view.removeFromSuperview()
        }
    }
    
}





struct Dimensions {
    var height: CGFloat
    var width: CGFloat
}

