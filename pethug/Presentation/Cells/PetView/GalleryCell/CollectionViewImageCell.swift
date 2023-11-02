//
//  CollectionViewImageCell.swift
//  pethug
//
//  Created by Raul Pena on 08/10/23.
//

import UIKit
import SDWebImage

protocol PetViewImageCellDelegate: AnyObject {
    func didTapCell(image: UIImage)
}

final class PetViewImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    lazy private var petImage: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.backgroundColor = customRGBColor(red: 0, green: 61, blue: 44)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    //MARK: - Internal properties
    weak var delegate: PetViewImageCellDelegate?
    
    //MARK: - LifeCycle
    func configure(with url: String) {
        configureCellUI(with: url)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubview(petImage)

        petImage.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    private var work: DispatchWorkItem?
    
    private func configureCellUI(with url: String) {
         work = DispatchWorkItem(block: { [weak self] in
             let url = URL(string: url)
             DispatchQueue.main.async {
                 self?.petImage.sd_setImage(with: url)
             }
        })
        
        DispatchQueue.main.async(execute: work!)
    }
    
    override func prepareForReuse() {
        work?.cancel()
        petImage.image = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private actions
    @objc private func didTapImage() {
        guard let image = petImage.image else { return }
        delegate?.didTapCell(image: image)
    }
    
}


