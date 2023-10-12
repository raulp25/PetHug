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
    private let petsSubject = PassthroughSubject<([Pet], Bool), PetsError>()
    private var pets: [Pet] = []
    private var isFetching = false
    private var isFirstLoad = true
    
    //MARK: - Init
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
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                let (pets, debounce) = data
                self.pets.append(contentsOf: pets)
                self.state.send(.loaded(self.pets, debounce))
            }.store(in: &subscriptions)
        
    }
    
    //MARK: - Internal Methods
    func fetchUserPets(resetPagination: Bool = false) {
        guard !isFetching else { return }
        
        if resetPagination {
            resetPets()
        }
        
        isFetching = true
        
        state.send(.loading)
        
        Task {
            do {
                let data = try await fetchUserPetsUC.execute(with: resetPagination)
                handleFetchedPets(data, resetPagination: resetPagination)
            } catch {
                handleFetchError(error)
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
    
    //MARK: - Private methods
    private func resetPets() {
        pets = []
    }

    private func handleFetchedPets(_ data: [Pet], resetPagination: Bool) {
        if !isFirstLoad && !data.isEmpty {
            let debounce = resetPagination ? true : false
            petsSubject.send((data, debounce))
        } else if isFirstLoad {
            petsSubject.send((data, false))
            isFirstLoad = false
        }
    }

    private func handleFetchError(_ error: Error) {
        state.send(.error(.default(error)))
    }
}


