//
//  PetCell.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import UIKit
import SDWebImage
import FirebaseFirestore
protocol PetContentDelegate: AnyObject {
    func didTapLike(_ pet: Pet, completion: @escaping (Bool) -> Void)
    func didTapDislike(_ pet: Pet, completion: @escaping (Bool) -> Void)
    func didTapCell(pet: Pet)
}

final class PetControllerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private components
    lazy private var petImage: UIImageView = {
       let iv = UIImageView()
        let k = Int(arc4random_uniform(6))
        iv.backgroundColor = customRGBColor(red: 0, green: 61, blue: 44)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10 
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private lazy var heartImageContainer: UIView = {
       let uv = UIView(withAutolayout: true)
        uv.layer.cornerRadius = 7
        uv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        uv.addGestureRecognizer(tapGesture)
        return uv
    }()
    
    let blurView: UIVisualEffectView = {
        let vv = UIVisualEffectView()
        vv.clipsToBounds = true
        vv.layer.cornerRadius = 7
        vv.translatesAutoresizingMaskIntoConstraints = false
        vv.backgroundColor = customRGBColor(red: 240, green: 245, blue: 246, alpha: 0.4)
       return vv
    }()
    
    let blurEffect  = UIBlurEffect(style: .regular)
    
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
        
        addSubview(heartImageContainer)
        heartImageContainer.addSubview(blurView)
        heartImageContainer.addSubview(heartImage)
        
        addSubview(name)
        addSubview(address)
        
        petImage.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        petImage.setHeight(frame.height / 2.6 * 2)
        
        heartImageContainer.anchor(
            top: topAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingRight: 5
        )
        heartImageContainer.setDimensions(height: 24, width: 24)
        heartImageContainer.bringSubviewToFront(heartImage)
        
        blurView.fillSuperview()
        blurView.effect = blurEffect
        
        heartImage.center(
            inView: heartImageContainer
        )
        
        name.anchor(
            top: petImage.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 5
        )
        address.anchor(
            top: name.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 5
        )
    }
    
    private var work: DispatchWorkItem? 
    private var checkLikesWork: DispatchWorkItem?
    private var db = Firestore.firestore()
    private func configureCellUI(with viewModel: PetCellViewModel) {
        
        
         work = DispatchWorkItem(block: { [weak self] in
//             let imageDownloader = ImageService()
//             imageDownloader.downloadImage(url: viewModel.petImage) { image in
//                 if let image = image {
//                     DispatchQueue.main.async {
//                         self.petImage.image = UIImage(data: image)
//                     }
//                 }
//             }
             self?.petImage.image = UIImage(named: viewModel.petImage)
             let url = URL(string: viewModel.petImage)
             DispatchQueue.main.async {
                 self?.petImage.sd_setImage(with: url)
             }
        })
        
        DispatchQueue.main.async(execute: work!)
        
        // Check if user likes pet
        let uid = AuthService().uid
        if viewModel.pet.likedByUsers.contains(uid) {
            viewModel.isLiked = true
        }
        heartImage.image = UIImage(systemName: viewModel.heartImage)
        
        name.text = viewModel.name
        address.text = viewModel.address.rawValue
    }
    
    override func prepareForReuse() {
        work?.cancel()
        checkLikesWork?.cancel()
        viewModel = nil
        petImage.image = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Actions
    @objc func didTapCell() {
        guard let viewModel = viewModel else { return }
        delegate?.didTapCell(pet: viewModel.pet)
    }
    
    @objc private func didTapLike(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        guard let delegate = delegate else { return }
        
        heartImageContainer.isUserInteractionEnabled = false
        // Like pet
        if !viewModel.isLiked {
            delegate.didTapLike(viewModel.pet) { [weak self] result in
                // If like process was unsuccessful reset like state
                if result == false {
                    viewModel.isLiked.toggle()
                    DispatchQueue.main.async {
                        self?.heartImage.image = UIImage(systemName: viewModel.heartImage)
                    }
                }
                DispatchQueue.main.async {
                    self?.heartImageContainer.isUserInteractionEnabled = true
                }
            }
        }
        
        //Dislike pet
        if viewModel.isLiked {
            delegate.didTapDislike(viewModel.pet) { [weak self] result in
                // If like process was unsuccessful reset like state
                if result == false {
                    viewModel.isLiked.toggle()
                    DispatchQueue.main.async {
                        self?.heartImage.image = UIImage(systemName: viewModel.heartImage)
                    }
                }
                DispatchQueue.main.async {
                    self?.heartImageContainer.isUserInteractionEnabled = true
                }
            }
        }
        
        viewModel.isLiked.toggle()
        heartImage.image = UIImage(systemName: viewModel.heartImage)
    }

}
