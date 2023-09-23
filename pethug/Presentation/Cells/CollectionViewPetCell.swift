//
//  PetCell.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit

final class PetControllerCollectionViewCell: UICollectionViewCell {
    
    let petImage: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.image = UIImage(named: k < 1 ? "sal" : "pr\(k)")
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10 
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var heartImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.backgroundColor = customRGBColor(red: 240, green: 245, blue: 246)
        uv.layer.cornerRadius = 7
        uv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    private let heartImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.tintColor = UIColor.red
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let name: UILabel = {
       let label = UILabel()
        label.text = "Bruno"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black.withAlphaComponent(0.75)
        label.textAlignment = .left
        return label
    }()
    
    let address: UILabel = {
       let label = UILabel()
        label.text = "Huixquilucan Estado de Mexico"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.75)
        label.textAlignment = .left
        return label
    }()
    
    var liked = false
    
    var action: ((_ cellId: String) -> Void)? = nil
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        let dummyView = UIView()
        dummyView.backgroundColor = .systemPink.withAlphaComponent(0.5)
        
        
        addSubview(petImage)
        sendSubviewToBack(petImage)
        
        addSubview(heartImageContainer)
        heartImageContainer.addSubview(heartImage)
        
        addSubview(name)
        addSubview(address)
        
        petImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        petImage.setHeight(frame.height / 2.6 * 2)
        
        heartImageContainer.anchor(top: topAnchor, right: rightAnchor, paddingTop: 5, paddingRight: 5)
        heartImageContainer.setDimensions(height: 24, width: 24)
        
        heartImage.center(inView: heartImageContainer)
        
        name.anchor(top: petImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
        address.anchor(top: name.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLike(_ sender: UITapGestureRecognizer) {
        if let action = action {
            action("")
        }
        print("clicked liked")
        liked = !liked
        let image = liked ?  "heart.fill" : "heart"
        heartImage.image = UIImage(systemName: image)
    }

}
