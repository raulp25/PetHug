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
    
    lazy var nameTextField: UITextField = {
        let txtField = UITextField(frame: .zero)
        txtField.textColor = .label
        txtField.tintColor = .orange
        txtField.textAlignment = .left
        txtField.font = .systemFont(ofSize: 16, weight: .regular)
        txtField.backgroundColor = .clear
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return txtField
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
    
    // MARK: - Private actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
//        currentConfiguration.viewModel?.delegate?.textViewdDidChange(text: textField.text ?? "")
        
//        currentConfiguration.viewModel?.formData.info = textField.text
//        print("textfield did change text viewmodel I N F O: => \(currentConfiguration.viewModel?.formData.info)")
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        currentConfiguration.viewModel?.formData.info = textView.text
        currentConfiguration.viewModel?.delegate?.textViewdDidChange(text: textView.text)
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetInfoListCellConfiguration) {
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
    
    
    let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        uv.backgroundColor = .white
        return uv
    }()
    
    private func setup() {
        
        let textView = CustomTextView()
        textView.placeHolderText = "Añade información adicional"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.clipsToBounds = true
        textView.delegate = self
        textView.tintColor = .systemOrange
//        tv.delegate = self
        backgroundColor = customRGBColor(red: 246, green: 246, blue: 246)
        
        addSubview(titleLabel)
        addSubview(containerView)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        containerView.addSubview(textView)
        containerView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 30)
        containerView.setHeight(120)
        
        containerView.layer.cornerRadius = 10
        textView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor , right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        
    }
    
}

extension NewPetInfoCellContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
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
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self //
        translatesAutoresizingMaskIntoConstraints = true
        isScrollEnabled = true
        showsVerticalScrollIndicator = false
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 7, paddingLeft: 5)
        
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


