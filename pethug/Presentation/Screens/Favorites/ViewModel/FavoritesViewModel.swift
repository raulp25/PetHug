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
    private var pets: [Pet] = []
    
    private var isFetching = false
    private var isFirstLoad = true
    private let fetchFavoritePetsUC: DefaultFetchFavoritePetsUC
    private let dislikedPetUC: DefaultDisLikePetUC
    
    init(
        fetchFavoritePetsUC: DefaultFetchFavoritePetsUC,
        dislikePetUC: DefaultDisLikePetUC
    ) {
        self.fetchFavoritePetsUC = fetchFavoritePetsUC
        self.dislikedPetUC = dislikePetUC
        observeState()
        fetchFavoritePets()
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
    func fetchFavoritePets(resetData: Bool = false) {
        guard !isFetching else { return }
        if resetData {
            pets = []
        }
        isFetching = true
        
        Task {
            do {
                guard NetworkMonitor.shared.isConnected == true else {
                    self.state.send(.networkError)
                    isFetching = false
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
            
            isFetching = false
        }
    }
    
    
    func dislikedPet(pet: Pet, completion: @escaping(Bool) -> Void) {
        Task{
            do {
                guard NetworkMonitor.shared.isConnected == true else {
                    state.send(.networkError)
                    completion(false)
                    return
                }
                
                let pet = try removeLikeUid(pet: pet)
                try delete(pet: pet)
                try await dislikedPetUC.execute(data: pet)
                completion(true)
            } catch {
                print("error liking pet: => \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func removeLikeUid(pet: Pet) throws -> Pet {
        let uid = AuthService().uid
        
        if !pet.likedByUsers.contains(uid) {
            throw PetsError.defaultCustom("User's uid was not found in likedByUsers")
        }
        
        if let index = pet.likedByUsers.firstIndex(of: uid) {
            let updatedPet = pet
            updatedPet.likedByUsers.remove(at: index)
            return updatedPet
        } else {
            throw PetsError.defaultCustom("User's UID not found in likedByUsers")
        }
    }
    
    func delete(pet: Pet) throws {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets.remove(at: index)
        } else {
            throw PetsError.defaultCustom("Pet ID not found Pets array")
        }
    }
}

