//
//  ProfileViewModel.swift
//  pethug
//
//  Created by Raul Pena on 20/10/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

final class ProfileViewModel {
    //MARK: - Internal Properties
    var state = PassthroughSubject<State,Never>()
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let imageSubject = PassthroughSubject<UIImage, PetsError>()
    private let updateUserUC: DefaultUpdateUserUC
    private let deleteUserUC: DefaultDeleteUserUC
    private let imageService: ImageServiceProtocol
    private let authService: AuthServiceProtocol
    
    var user: User? = nil
    
    init(
        updateUserUC: DefaultUpdateUserUC,
        deleteUserUC: DefaultDeleteUserUC,
        imageService: ImageServiceProtocol,
        authService: AuthServiceProtocol
    ) {
        self.updateUserUC = updateUserUC
        self.deleteUserUC = deleteUserUC
        self.imageService = imageService
        self.authService  = authService
    }
    
    deinit {
        print("✅ Deinit ProfileViewModel")
    }
    
    //MARK: - Internal Methods
    func updateProfilePic(image: UIImage) async {
        state.send(.loading)
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                state.send(.networkError)
                return
            }
            
            if let oldProfilePic = user?.profileImageUrl {
                imageService.deleteImages(imagesUrl: [oldProfilePic]) // Delete image
            }
            
            let path = "/user_Profile_Image:\(authService.uid)/"
            let imageUrl = try await imageService.uploadImage(image: image, path: path) // Upload image
            
            try await updateUserUC.execute(imageUrl: imageUrl!)
            
            state.send(.loaded)
            
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    func deleteUser() async {
        state.send(.loading)
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                state.send(.networkError)
                return
            }
            try await authService.reloadUser()
            try await deleteUserUC.execute()
        } catch {
            state.send(.deleteUserError)
        }
    }
  
}
