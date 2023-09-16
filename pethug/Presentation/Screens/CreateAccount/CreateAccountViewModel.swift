//
//  CreateAccountViewModel.swift
//  pethug
//
//  Created by Raul Pena on 14/09/23.
//

import UIKit
import Combine

struct CreateAcoountViewModel {
    enum State {
        case loading
        case success
        case error(MessengerError)
    }
    
    var profileImage: UIImage?
    
    var state = PassthroughSubject<State, Never>()
    
    private let authService: AuthServiceProtocol
    private let imageService: ImageServiceProtocol
    init(authService: AuthServiceProtocol, imageService: ImageServiceProtocol) {
        self.authService = authService
        self.imageService = imageService
    }
    
//    func k() {
//        state.send(.loading)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute:{
//            state.send(.success)
//        })
//    }
    
    func crateAccount(username: String, email: String, password: String) async throws {
        state.send(.loading)
        
        do {
            
            var imageUrl: String? = nil
            if let image = profileImage {
                imageUrl =  try await imageService.uploadImage(image: image)?.absoluteString
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
            
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    func registerUser(user: User) async throws {
        
        let userRepo = DefaultUserRepository(userDataSource: DefaultUserDataSource())
        
        let result = try await userRepo.registerUser(user: user)
        
        switch result {
        case .success(_):
            state.send(.success)
        case .failure(let error):
            state.send(.error(.default(error)))
        }
    }
    
    
}

