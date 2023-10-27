//
//  NewPetInfoCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 28/09/23.
//

import UIKit

final class NewPetInfoCellContentView: UIView, UIContentView, UITextViewDelegate {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Informacion adicional"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.text = "* Datos de contacto e historia del animal"
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()

    lazy var textView: CustomTextView = {
        let textView = CustomTextView()
        textView.placeHolderText = "Añade información adicional"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.clipsToBounds = true
        textView.tintColor = .systemOrange
        
        textView.delegate = self
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "0/1600"
        return label
    }()
    
    // MARK: - Properties
    private var currentConfiguration: NewPetInfoListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetInfoListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetInfoListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()

        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 1600 {
            textView.deleteBackward()
        }
        
        currentConfiguration.viewModel?.delegate?.textViewdDidChange(text: textView.text)
        characterCountLabel.text = "\(textView.text.count)/1600"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetInfoListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration
//
        guard let item = currentConfiguration.viewModel else { return }
        
        if item.info != nil {
            textView.text = item.info
            textView.placeholderLabel.isHidden = true
            characterCountLabel.text = "\(item.info!.count)/1600"
        }
    }
    
    
    let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        return uv
    }()
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(captionLabel)
        addSubview(containerView)
        containerView.addSubview(textView)
        
        addSubview(characterCountLabel)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        
        captionLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor
        )

        containerView.anchor(
            top: captionLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 10
        )
        containerView.setHeight(120)
        containerView.layer.cornerRadius = 10
        
        textView.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingTop: 10,
            paddingLeft: 10,
            paddingBottom: 10,
            paddingRight: 10
        )
        
        characterCountLabel.anchor(
            top: containerView.bottomAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 30,
            paddingRight: 10
        )
        characterCountLabel.setHeight(20)
        
    }
    
}

protocol CustomTextViewDelegate: AnyObject {
    func textDidchange()
}

class CustomTextView: UITextView {
    
    //MARK: - Properties
    var placeHolderText: String? {
        didSet { placeholderLabel.text = placeHolderText }
    }
    
    var delegate2: CustomTextViewDelegate?
    
     let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    
    var paddingTop: CGFloat? = nil
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self 
        translatesAutoresizingMaskIntoConstraints = true
        isScrollEnabled = true
        showsVerticalScrollIndicator = false
        
        addSubview(placeholderLabel)
        
        placeholderLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: paddingTop ?? 7,
            paddingLeft: 5
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Observed functions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
}
extension CustomTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        delegate2?.textDidchange()
        
        // Calculate the text size
        let size = textView.sizeThatFits(textView.bounds.size)
        
        // Limit the height to 5 rows of text
        let maxHeight: CGFloat = CGFloat(5) * textView.font!.lineHeight
        
        // Adjust the text view's frame if necessary
        if size.height <= maxHeight {
            textView.isScrollEnabled = false
            textView.frame.size.height = size.height
        } else {
            textView.isScrollEnabled = true
            textView.frame.size.height = maxHeight
        }
    }
}


