//
//  NewPetActivityCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import UIKit
import MultiSlider

final class NewPetActivityCellContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "En una escala del 1 (menor) al 10 (mayor) indica que tan activo es el animal"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.3, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let activityLabel: UILabel = {
       let label = UILabel()
        label.text = "Actividad: 0"
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
    private var currentConfiguration: NewPetActivityListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? NewPetActivityListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: NewPetActivityListCellConfiguration) {
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
        currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: Int(vals[0]))
        activityLabel.text = "Actividad: \(Int(vals[0]))"
    }
    
    // MARK: - Functions
    private func apply(configuration: NewPetActivityListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let activityLevel = currentConfiguration.viewModel?.activityLevel else { return }
        slider.value = [CGFloat(activityLevel)]
        activityLabel.text = "Actividad: \(activityLevel)"
        
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(activityLabel)
        addSubview(slider)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        
        activityLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            paddingTop: 15
        )
        
        slider.anchor(
            top: activityLabel.topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 20,
            paddingBottom: 30
        )
        
    }
    
}



