//
//  CollectionViewPetCell.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import UIKit

protocol AddPetContentDelegate: AnyObject {
    func didTap(_ pet: AddPetContentViewController.Item)
}

final class AddPetControllerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    let petImage: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.backgroundColor = customRGBColor(red: 0, green: 61, blue: 44)
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
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
    
    //MARK: - Private properties
    private var viewModel: PetCellViewModel?
    private weak var delegate: PetContentDelegate?
    //MARK: - Internal properties
    var liked = false
    
    var action: ((_ cellId: String) -> Void)? = nil
    
    //MARK: - LifeCycle
    func configure(with pet: Pet, delegate: PetContentDelegate? = nil) {
        viewModel = .init(pet: pet)
        self.delegate = delegate
        guard viewModel != nil else { return }
        configureCellUI(with: viewModel!)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        let dummyView = UIView()
        dummyView.backgroundColor = .systemPink.withAlphaComponent(0.5)
        
        
        addSubview(petImage)
        sendSubviewToBack(petImage)
        
        addSubview(name)
        addSubview(address)
        
        petImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        petImage.setHeight(frame.height / 2.6 * 2)
        
        
        name.anchor(top: petImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
        address.anchor(top: name.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
    }
    
    private var work: DispatchWorkItem?
    
    private func configureCellUI(with viewModel: PetCellViewModel) {
         work = DispatchWorkItem(block: {
             self.petImage.image = UIImage(named: viewModel.petImage)
        })
        
        let randomNumber = CGFloat(Int(arc4random_uniform(2)))
        DispatchQueue.main.asyncAfter(deadline: .now() + randomNumber, execute: work!)
        
        name.text = viewModel.name
        address.text = viewModel.address.rawValue
    }
    
    override func prepareForReuse() {
        work?.cancel()
        viewModel = nil
        petImage.image = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

