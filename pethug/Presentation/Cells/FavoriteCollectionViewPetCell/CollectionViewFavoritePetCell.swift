//
//  CollectionViewFavoritePetCell.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import UIKit
import SDWebImage
import FirebaseFirestore
protocol FavoriteContentDelegate: AnyObject {
    func didTapDislike(_ pet: FavoritesContentViewController.Item, completion: @escaping (Bool) -> Void)
    func didTapCell(pet: Pet)
}

final class FavoriteControllerCollectionViewCell: UICollectionViewCell {
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDisLike))
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
    private var viewModel: FavoriteCellViewModel?
    private weak var delegate: FavoriteContentDelegate?
    
    //MARK: - Internal properties
    var liked = false
    
    //MARK: - LifeCycle
    func configure(with pet: Pet, delegate: FavoriteContentDelegate? = nil) {
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
        heartImageContainer.bringSubviewToFront(heartImage)
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
    private func configureCellUI(with viewModel: FavoriteCellViewModel) {
        
        // Download image
         work = DispatchWorkItem(block: {
             let imageDownloader = ImageService()
             // Donwload pet image
             imageDownloader.downloadImage(url: viewModel.petImage) { image in
                 if let image = image {
                     DispatchQueue.main.async { [weak self] in
                         self?.petImage.image = UIImage(data: image)
                     }
                 }
             }
//             self.petImage.image = UIImage(named: viewModel.petImage)
//             let url = URL(string: viewModel.petImage)
//             self.petImage.sd_setImage(with: url)
        })
        
        DispatchQueue.main.async(execute: work!)
        
        // Check if user likes this pet
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
    
    //Dislike pet tapped
    @objc private func didTapDisLike(_ sender: UITapGestureRecognizer) {
        guard let viewModel = viewModel else { return }
        guard let delegate = delegate else { return }
        
        heartImageContainer.isUserInteractionEnabled = false
        
        if viewModel.isLiked {
            delegate.didTapDislike(.pet(viewModel.pet)) { [weak self] result in
                // In case something goes wrong with the process we still update the UI
                // to let the user know his attempted action was received
                if result == false {
                    viewModel.isLiked.toggle()// Toggle liked state
                    DispatchQueue.main.async {
                        self?.heartImage.image = UIImage(systemName: viewModel.heartImage) // Update image
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

