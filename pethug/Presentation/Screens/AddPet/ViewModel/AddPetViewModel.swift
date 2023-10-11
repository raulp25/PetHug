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
    private let fetchUserPetsUC: DefaultFetchUserPetsUC
    private let deletePetUC: DefaultDeletePetUC
    private let deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    
    private var subscriptions = Set<AnyCancellable>()
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private var pets: [Pet] = []
    private var isFetching = false
    
    ///Change to FetchUserPetsUC
    init(
        fetchUserPetsUC: DefaultFetchUserPetsUC,
        deletePetUC: DefaultDeletePetUC,
        deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    ) {
        self.fetchUserPetsUC = fetchUserPetsUC
        self.deletePetUC = deletePetUC
        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
        
        observeState()
        fetchUserPets()
    }
    
    deinit {
        print("✅ Deinit PetsViewModel")
    }
    
    //MARK: - Internal Methods
    func fetchUserPets(resetPagination: Bool = false) {
        guard !isFetching else { return }
        if resetPagination {
            pets = []
        }
        isFetching = true
        
        Task {
            state.send(.loading)
            do {
                let data = try await fetchUserPetsUC.execute(with: resetPagination)
                guard !data.isEmpty else { return }
                petsSubject.send(data)
                
            } catch {
                state.send(.error(.default(error)))
            }
            
            isFetching = false
        }
    }
    
    
    func deletePet(collection path: String,  id: String) async -> Bool {
        await withThrowingTaskGroup(of: Void.self) { [unowned self] group in
            group.addTask { let _ = try await self.deletePetUC.execute(collection: path, docId: id) }
            group.addTask { let _ = try await self.deletePetFromRepeatedCollectionUC.execute(collection: path, docId: id) }
        }
        
        if let index = pets.firstIndex(where: { $0.id == id }) {
            pets.remove(at: index)
        }
        //Check if we refactor this function to not return bool
        //since everything is handled by firebase
        return true
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
}


