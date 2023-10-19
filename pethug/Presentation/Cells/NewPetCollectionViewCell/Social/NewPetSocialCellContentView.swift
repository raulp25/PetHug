//
//  NewPetSocialCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit
import MultiSlider

final class NewPetSocialCellContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "En una escala del 1 (menor) al 10 (mayor) indica que tan social es el animal"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let socialLabel: UILabel = {
       let label = UILabel()
        label.text = "Social: 0"
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .medium)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private lazy var slider: MultiSlider = {
        let horizontalMultiSlider = MultiSlider()
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.outerTrackColor = customRGBColor(red: 210, green: 210, blue: 210)
        horizontalMultiSlider.tintColor = .orange
        horizontalMultiSlider.valueLabelPosition = .top
        horizontalMultiSlider.trackWidth = 5
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.valueLabelAlternatePosition = false
        horizontalMultiSlider.valueLabelPosition = .bottom
        horizontalMultiSlider.valueLabelFormatter.positiveSuffix = ""
        horizontalMultiSlider.valueLabelFont = UIFont.systemFont(ofSize: 11, weight: .light, width: .expanded)
        
        horizontalMultiSlider.minimumValue = 0
        horizontalMultiSlider.maximumValue = 10
        horizontalMultiSlider.value = [0]
        horizontalMultiSlider.snapValues = [0,1,2,3,4,5,6,7,8,9,10]
        
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        return horizontalMultiSlider
    }()
    
    
    // MARK: - Properties
    private var currentConfiguration: NewPetSocialListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetSocialListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetSocialListCellConfiguration) {
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
    @objc func sliderChanged(slider: MultiSlider) {
        let vals: [CGFloat] = slider.value
        currentConfiguration.viewModel?.delegate?.socialLevelChanged(to: Int(vals[0]))
        socialLabel.text = "Social: \(Int(vals[0]))"
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetSocialListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let socialLevel = currentConfiguration.viewModel?.socialLevel else { return }
        slider.value = [CGFloat(socialLevel)]
        socialLabel.text = "Social: \(socialLevel)"
        
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(socialLabel)
        addSubview(slider)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        socialLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            paddingTop: 15
        )
        
        slider.anchor(
            top: socialLabel.topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 20,
            paddingBottom: 30
        )
        
    }
    
}




