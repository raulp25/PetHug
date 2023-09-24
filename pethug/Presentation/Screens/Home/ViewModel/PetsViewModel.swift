//
//  PetsViewModel.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
import Combine
import FirebaseFirestore
protocol PetsNavigatable: AnyObject {
    func tapped(pet: Pet)
}

final class PetsViewModel {
    //MARK: - Internal Properties
    weak var navigation: PetsNavigatable?
    var state = CurrentValueSubject<State,Never>(.loading)
    
//    var fetchPetsUseCase
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private var pets: [Pet] = []
    
    private let fetchPetsUC: DefaultFetchPetsUC
    
    
    init(fetchPetsUC: DefaultFetchPetsUC) {
        self.fetchPetsUC = fetchPetsUC
//        observeState()
//        fetchPets(collection: .getPath(for: .dogs))
    }
    
    deinit {
        print("✅ Deinit PetsViewModel")
    }
    
    //MARK: - Private methods
    private func fetchPets(collection: String) {
        Task {
            state.send(.loading)
            do {
                let data = try await fetchPetsUC.execute(fetchCollection: .getPath(for: .dogs))
                print("data en fetch pets(): => \(data)")
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
            self?.state.send(.loaded(pets))
        }.store(in: &subscriptions)

    }
    
    
}


