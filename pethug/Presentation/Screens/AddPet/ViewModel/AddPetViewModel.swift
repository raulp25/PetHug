//
//  AddPetViewModel.swift
//  pethug
//
//  Created by Raul Pena on 26/09/23.
//

import Foundation
import Combine
import FirebaseFirestore

protocol AddPetNavigatable: AnyObject {
    func startAddPetFlow()
    func startEditPetFlow(pet: Pet)
}

final class AddPetViewModel {
    //MARK: - Internal Properties
    weak var navigation: AddPetNavigatable?
    var state = CurrentValueSubject<State,Never>(.loading)
    
    //    var fetchPetsUseCase
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private var pets: [Pet] = []
    
    private let fetchUserPetsUC: DefaultFetchUserPetsUC
    
    ///Change to FetchUserPetsUC
    init(fetchUserPetsUC: DefaultFetchUserPetsUC) {
        self.fetchUserPetsUC = fetchUserPetsUC
        observeState()
    }
    
    deinit {
        print("✅ Deinit PetsViewModel")
    }
    
    //MARK: - Private methods
    func fetchPets(collection: String) {
        Task {
            state.send(.loading)
            do {
                let data = try await fetchUserPetsUC.execute()
                petsSubject.send(data)
            } catch {
                state.send(.error(.default(error)))
            }
        }
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
                self?.pets.append(contentsOf: pets)
                self?.state.send(.loaded(pets))
            }.store(in: &subscriptions)
        
    }   
}


