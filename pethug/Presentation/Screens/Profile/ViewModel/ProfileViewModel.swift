//
//  ProfileViewModel.swift
//  pethug
//
//  Created by Raul Pena on 20/10/23.
//

import Foundation
import Combine
import FirebaseFirestore
import Firebase
//protocol FavoritesNavigatable: AnyObject {
//    func tapped(pet: Pet)
//}

final class ProfileViewModel {
    //MARK: - Internal Properties
    var state = PassthroughSubject<State,Never>()
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let imageSubject = PassthroughSubject<UIImage, PetsError>()
    private let updateUserUC: DefaultUpdateUserUC
    private let imageService: ImageServiceProtocol
    
    var user: User? = nil
    
    init(
        updateUserUC: DefaultUpdateUserUC,
        imageService: ImageServiceProtocol
    ) {
        self.updateUserUC = updateUserUC
        self.imageService = imageService
    }
    
    deinit {
        print("✅ Deinit ProfileViewModel")
    }
    
    //MARK: - Internal Methods
    func updateProfilePic(image: UIImage) async {
        state.send(.loading)
        
        do {
            if let oldProfilePic = user?.profileImageUrl {
                try imageService.deleteImages(imagesUrl: [oldProfilePic])
            }
            
            let imageUrl =  try await imageService.uploadImage(image: image, path: .getStoragePath(for: .users))
            
            try await updateUserUC.execute(imageUrl: imageUrl!)
            
            state.send(.loaded)
            
        } catch {
            state.send(.error(.default(error)))
        }
    }
  
}
