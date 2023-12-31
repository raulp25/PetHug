//
//  FavoritesViewModel.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import Foundation
import Combine
import FirebaseFirestore
import Firebase
protocol FavoritesNavigatable: AnyObject {
    func tapped(pet: Pet)
}

final class FavoritesViewModel {
    //MARK: - Internal Properties
    weak var navigation: FavoritesNavigatable?
    var state = PassthroughSubject<State,Never>()
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private(set) var pets: [Pet] = []
    
    private(set) var isFetching = false
    private let fetchFavoritePetsUC: DefaultFetchFavoritePetsUC
    private let dislikedPetUC: DefaultDisLikePetUC
    private let authService: AuthServiceProtocol
    
    init(
        fetchFavoritePetsUC: DefaultFetchFavoritePetsUC,
        dislikePetUC: DefaultDisLikePetUC,
        authService: AuthServiceProtocol
    ) {
        self.fetchFavoritePetsUC = fetchFavoritePetsUC
        self.dislikedPetUC = dislikePetUC
        self.authService = authService
        observeState()
    }
    
    deinit {
        print("✅ Deinit FavoritesViewModel")
    }
    
    // MARK: - Private observers
    private func observeState() {
        petsSubject
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    print("Error retreiving pets: => \(err)")
                }
            } receiveValue: { [weak self] pets in
                guard let self = self else { return }
                self.pets.append(contentsOf: pets)
                self.state.send(.loaded(self.pets))
            }.store(in: &subscriptions)
        
    }
    
    //MARK: - Internal Methods
    func fetchFavoritePets(resetData: Bool = false) async {
        guard !isFetching else { return }
        if resetData {
            pets = []
        }
        
        isFetching = true
        defer {
            isFetching = false
        }
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let data = try await fetchFavoritePetsUC.execute()
            
            if data.isEmpty {
                state.send(.empty)
            } else {
                petsSubject.send(data)
            }
            
        } catch {
            state.send(.error(.default(error)))
        }
    }
    
    
    func dislikedPet(pet: Pet, completion: @escaping(Bool) -> Void) async {
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                state.send(.networkError)
                completion(false)
                return
            }
            
            let pet = try removeLikeUid(pet: pet)
            try deleteLiked(pet: pet)
            try await dislikedPetUC.execute(data: pet)
            completion(true)
        } catch {
            print("error liking pet: => \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeLikeUid(pet: Pet) throws -> Pet {
        let uid = authService.uid
        
        if !pet.likedByUsers.contains(uid) {
            throw PetsError.defaultCustom("User's uid was not found in likedByUsers")
        }
        
        if let index = pet.likedByUsers.firstIndex(of: uid),
           let timestampIndex = pet.likesTimestamps.firstIndex(where: { $0.uid == uid })
        {
            let updatedPet = pet
            updatedPet.likedByUsers.remove(at: index)
            updatedPet.likesTimestamps.remove(at: timestampIndex)
            return updatedPet
        } else {
            throw PetsError.defaultCustom("User's UID not found in likedByUsers")
        }
    }
    
    func deleteLiked(pet: Pet) throws {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets.remove(at: index)
        } else {
            throw PetsError.defaultCustom("Pet ID not found Pets array")
        }
    }
}

