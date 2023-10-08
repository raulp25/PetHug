//
//  CollectionViewInfoLocationCell.swift
//  pethug
//
//  Created by Raul Pena on 07/10/23.
//

import UIKit
import SDWebImage


final class PetViewInfoCollectionViewCell: UICollectionViewCell {

    //MARK: - Private components
    private lazy var hStackFirstRow: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .white
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var ageBadge: Badge? = nil
    private var genderBadge: Badge? = nil
    private var sizeBadge: Badge? = nil
    
    
    private lazy var hStackSecondRow: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .white
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var activityBadge: Badge? = nil
    private var socialBadge: Badge? = nil
    private var affectionBadge: Badge? = nil
    
    
    //MARK: - LifeCycle
    func configure(with info: InfoData) {
        configureCellUI(with: info)
        configureConstraints()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    private var work: DispatchWorkItem?
        
    private func configureCellUI(with info: InfoData) {
        var genderBadgeIcon = ""
        switch info.gender {
        case .male:
            genderBadgeIcon = "m.square"
        case .female:
            genderBadgeIcon = "h.square"
        case .none:
            genderBadgeIcon = "circle.slash"
        }
        
        var sizeBadgeIcon = ""
        switch info.size {
        case .small:
            sizeBadgeIcon = "s.square"
        case .medium:
            sizeBadgeIcon = "m.square"
        case .large:
            sizeBadgeIcon = "g.square"
        case .none:
            sizeBadgeIcon = "circle.slash"
        }
        
        ageBadge    = Badge(titleText: "Edad", captionText: String(info.age), iconImageName: nil)
        genderBadge = Badge(titleText: "Género", captionText: nil, iconImageName: genderBadgeIcon)
        sizeBadge   = Badge(titleText: "Tamaño", captionText: nil, iconImageName: sizeBadgeIcon)
        
        activityBadge  = Badge(titleText: "Actividad", captionText: String(info.activityLevel), iconImageName: nil)
        socialBadge    = Badge(titleText: "Social", captionText: String(info.socialLevel), iconImageName: nil)
        affectionBadge = Badge(titleText: "Cariñoso", captionText: String(info.affectionLevel), iconImageName: nil)
    }
    
    private func configureConstraints() {
        guard let ageBadge = ageBadge,
              let genderBadge = genderBadge,
              let sizeBadge = sizeBadge,
              let activityBadge = activityBadge,
              let socialBadge = socialBadge,
              let affectionBadge = affectionBadge
        else { return }
        
        let firstStackBadges = [
            ageBadge,
            genderBadge,
            sizeBadge,
        ]
        
        let secondStackBadges = [
            activityBadge,
            socialBadge,
            affectionBadge
        ]
        
        addSubview(hStackFirstRow)
        addSubview(hStackSecondRow)
        
        hStackFirstRow.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0)
        hStackFirstRow.setHeight(60)
        
        hStackSecondRow.anchor(top: hStackFirstRow.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15)
        hStackSecondRow.setHeight(60)
        
        for  badge in firstStackBadges {
            hStackFirstRow.addArrangedSubview(badge)
            badge.anchor(top: hStackFirstRow.topAnchor, bottom: hStackFirstRow.bottomAnchor)
            badge.layer.cornerRadius = 10
        }
        
        for badge in secondStackBadges {
            hStackSecondRow.addArrangedSubview(badge)
            badge.anchor(top: hStackSecondRow.topAnchor, bottom: hStackSecondRow.bottomAnchor)
            badge.layer.cornerRadius = 10
        }
    }
    
    override func prepareForReuse() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



