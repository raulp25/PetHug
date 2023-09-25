//
//  PetCell.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit

protocol PetContentDelegate: AnyObject {
    func didTapLike(_ pet: PetsContentViewController.Item)
}

final class PetControllerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    let petImage: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.backgroundColor = UIColor.blue
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
    
    //MARK: - Private properties
    private var viewModel: PetCellViewModel?
    private weak var delegate: PetContentDelegate?
    //MARK: - Internal properties
    var liked = false
    
    var action: ((_ cellId: String) -> Void)? = nil
    
    //MARK: - LifeCycle
    func configure(with pet: Pet, delegate: PetContentDelegate) {
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
    
    private var work: DispatchWorkItem?
    private var didMount: Bool = false
    
    private func configureCellUI(with viewModel: PetCellViewModel) {
        heartImage.image = UIImage(systemName: viewModel.heartImage)
        print("didMount al inicio: => \(didMount)")
        if didMount == true {
            return
        }
         work = DispatchWorkItem(block: {
             self.petImage.image = UIImage(named: viewModel.petImage)
        })
        let m = CGFloat(Int(arc4random_uniform(2)))
        DispatchQueue.main.asyncAfter(deadline: .now() + m, execute: work!)
        
        name.text = viewModel.name
        address.text = viewModel.address
        didMount = true
        
        print("didMount al final\(didMount)")
    }
    
    override func prepareForReuse() {
        work?.cancel()
        didMount = false
        petImage.image = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLike(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        viewModel.isLiked.toggle()
        heartImage.image = UIImage(systemName: viewModel.heartImage)
        delegate?.didTapLike(.pet(viewModel.pet))
    }

}
