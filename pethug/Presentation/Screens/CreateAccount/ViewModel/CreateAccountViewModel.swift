//
//  CreateAccountViewModel.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import UIKit
import Combine

struct CreateAccountViewModel {    
    var profileImage: UIImage?
    
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    private let imageService: ImageServiceProtocol
    private let registerUserUC: DefaultRegisterUserUC
    
    init(
        authService: AuthServiceProtocol,
        imageService: ImageServiceProtocol,
        registerUserUC: DefaultRegisterUserUC
    ) {
        self.authService = authService
        self.imageService = imageService
        self.registerUserUC = registerUserUC
    }
    
    
    func crateAccount(username: String?, email: String?, password: String?) async {
        guard let username, let email, let password else {
            state.send(.error(.someThingWentWrong))
            return
        }
        
        state.send(.loading)
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            var imageUrl: String? = nil
            if let image = profileImage {
                imageUrl =  try await imageService.uploadImage(image: image, path: .getStoragePath(for: .users)) //Upload image
            }
            
            let uid = try await authService.createAccounWith(email: email, password: password) //Create account
            
            let userNew = User(
                id: uid,
                username: username,
                email: email,
                bio: nil,
                profileImageUrl: imageUrl
            )
            
            try await registerUser(user: userNew) //Register user
            
            state.send(.success)
            
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    private func registerUser(user: User) async throws {
        try await registerUserUC.execute(user: user)
    }
    
    
}

