//
//  FilterPetsAgeCellContentView.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit
import MultiSlider

final class FilterPetsAgeCellContentView: UIView, UIContentView {
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Edad (Años)"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    private let containerView: UIView = {
        let uv = UIView(withAutolayout: true)
        return uv
    }()
    
    private let ageLabel: UILabel = {
       let label = UILabel()
        label.text = "Edad elegida: 0 - 25 años"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
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
        horizontalMultiSlider.keepsDistanceBetweenThumbs = false
        horizontalMultiSlider.valueLabelFormatter.positiveSuffix = ""
        horizontalMultiSlider.valueLabelFont = UIFont.systemFont(ofSize: 11, weight: .light, width: .expanded)
        
        horizontalMultiSlider.minimumValue = 0
        horizontalMultiSlider.maximumValue = 25
        horizontalMultiSlider.value = [0, 25]
        horizontalMultiSlider.snapValues = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
        
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        return horizontalMultiSlider
    }()
    
    private var ageKey = FilterKeys.filterAgeRange.rawValue
    
    // MARK: - ContentView Config
    private var currentConfiguration: FilterPetsAgeListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        } set {
            guard let newConfiguration = newValue as? FilterPetsAgeListCellConfiguration else {
                return
            }

            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - LifeCycle
    init(configuration: FilterPetsAgeListCellConfiguration) {
        super.init(frame: .zero)
        // create the content view UI
        setup()

        // apply the configuration (set data to UI elements / define custom content view appearance)
        apply(configuration: configuration)
        
        if let savedCheckedRawValue = UserDefaults.standard.value(forKey: ageKey) as? FilterAgeRange {
            slider.value = [CGFloat(savedCheckedRawValue.min), CGFloat(savedCheckedRawValue.max)]
        } else {
            
        }
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private actions
    @objc func sliderChanged(slider: MultiSlider) {
        let vals: [CGFloat] = slider.value
        currentConfiguration.viewModel?.delegate?.ageChanged(ageRange: .init(min: Int(vals[0]), max: Int(vals[1])))
        ageLabel.text = "Edad elegida: \(Int(vals[0])) - \(Int(vals[1])) años"
    }
    
    
    // MARK: - Setup
    private func apply(configuration: FilterPetsAgeListCellConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        guard let item = currentConfiguration.viewModel else { return }
        
        slider.value = [CGFloat(item.ageRange.min), CGFloat(item.ageRange.max)]
    }
    
    
    private func setup() {
        backgroundColor = customRGBColor(red: 244, green: 244, blue: 244)
        
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(slider)
        addSubview(ageLabel)
        
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        
        containerView.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 20
        )
        containerView.setHeight(40)
        
        slider.fillSuperview()
        
        ageLabel.anchor(
            top: containerView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 45,
            paddingBottom: 30
        )
    }
    
}
