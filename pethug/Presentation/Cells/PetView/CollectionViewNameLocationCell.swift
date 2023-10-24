//
//  CollectionViewNameLocationCell.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit
import SDWebImage


final class PetViewNameLocationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = customRGBColor(red: 70, green: 70, blue: 70)
        return label
    }()
    
    private let breedLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = customRGBColor(red: 255, green: 176, blue: 42)
        return label
    }()
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.textColor = customRGBColor(red: 255, green: 176, blue: 42)
        return label
    }()
    
    //MARK: - LifeCycle
    func configure(with nameLocationData: NameLocationData) {
        configureCellUI(with: nameLocationData)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(breedLabel)
        addSubview(addressLabel)
        
        nameLabel.centerX(
            inView: self,
            topAnchor: topAnchor
        )
        
        breedLabel.anchor(
            top: nameLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 5
        )
        
        addressLabel.anchor(
            top: breedLabel.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5
        )
    }
    
    private var work: DispatchWorkItem?
    
    private func configureCellUI(with nameLocationData: NameLocationData) {
        nameLabel.text = nameLocationData.name
        breedLabel.text = nameLocationData.breed
        addressLabel.text = nameLocationData.address
    }
    
    override func prepareForReuse() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


