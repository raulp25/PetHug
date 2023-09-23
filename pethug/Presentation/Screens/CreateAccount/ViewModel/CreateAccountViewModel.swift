//
//  CreateAccountViewModel.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import UIKit
import Combine

struct CreateAccountViewModel {
    enum State {
        case loading
        case success
        case error(PetsError)
    }
    
    var profileImage: UIImage?
    
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    private let imageService: ImageServiceProtocol
    private let useCase: DefaultRegisterUserUC
    
    init(authService: AuthServiceProtocol, imageService: ImageServiceProtocol, useCase: DefaultRegisterUserUC) {
        self.authService = authService
        self.imageService = imageService
        self.useCase = useCase
    }
    
//    func k() {
//        state.send(.loading)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:{
//            state.send(.success)
//        })
//    }
    
    func crateAccount(username: String?, email: String?, password: String?) async {
        guard let username, let email, let password else {
            state.send(.error(.someThingWentWrong))
            return
        }
        
        state.send(.loading)
        
        do {
            
            var imageUrl: String? = nil
            if let image = profileImage {
                imageUrl =  try await imageService.uploadImage(image: image)
            }
            
            let uid = try await authService.createAccounWith(email: email, password: password)
            
            let userNew = User(
                id: uid,
                username: username,
                email: email,
                bio: nil,
                profileImageUrl: imageUrl
            )
            
            try await registerUser(user: userNew)
            
            state.send(.success)
            
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    private func registerUser(user: User) async throws {
        try await useCase.execute(user: user)
    }
    
    
}

