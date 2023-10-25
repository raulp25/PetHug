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
    var state = PassthroughSubject<State,Never>()
    
    //MARK: - Private Properties
    private let imageService: ImageServiceProtocol
    private let fetchUserPetsUC: DefaultFetchUserPetsUC
    private let deletePetUC: DefaultDeletePetUC
    private let deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    
    private var subscriptions = Set<AnyCancellable>()
    private let petsSubject = PassthroughSubject<([Pet], Bool), PetsError>()
    private var pets: [Pet] = []
    private var isFetching = false
    private var isFirstLoad = true // Flag indicates if the pagination process has started
    var isNetworkOnline = true
    
    //MARK: - Init
    init(
        imageService: ImageServiceProtocol,
        fetchUserPetsUC: DefaultFetchUserPetsUC,
        deletePetUC: DefaultDeletePetUC,
        deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    ) {
        self.imageService = imageService
        self.fetchUserPetsUC = fetchUserPetsUC
        self.deletePetUC = deletePetUC
        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
        
        observeState()
    }
    
    deinit {
        print("✅ Deinit AddPetViewModel")
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
        
        // Reset state variables when performing new fech after creating/updating pet
        if resetPagination {
            resetPets()
        }
        
        isFetching = true
        
        state.send(.loading)
        
        Task {
            do {
                guard NetworkMonitor.shared.isConnected == true else {
                    state.send(.networkError)
                    isFetching = false
                    isNetworkOnline = false
                    return
                }
                
                isNetworkOnline = true  
                let data = try await fetchUserPetsUC.execute(with: resetPagination) // Fetch user pets
                handleFetchedPets(data, resetPagination: resetPagination) // Handle results
            } catch {
                handleFetchError(error)
            }
            
            isFetching = false
        }
    }
    
    func deletePet(collection path: String,  id: String) async -> Bool {
        do{
            guard NetworkMonitor.shared.isConnected == true else {
                state.send(.networkError)
                return false
            }
            if let pet = pets.first(where: { $0.id == id}) {
                await withThrowingTaskGroup(of: Void.self) { [unowned self] group in
                    group.addTask{ self.imageService.deleteImages(imagesUrl: pet.imagesUrls) }
                    group.addTask { let _ = try await self.deletePetUC.execute(collection: path, docId: id) } // Delete from owner user collection
                    group.addTask { let _ = try await self.deletePetFromRepeatedCollectionUC.execute(collection: path, docId: id) } // Delete from pet collection
                }
                
                if let index = pets.firstIndex(where: { $0.id == id }) {
                    pets.remove(at: index) // Remove from pets array
                }
                return true
            }
        } catch {
            print("Error deleting pet in Addpet module => \(error)")
        }
        return false
    }
    
    //MARK: - Private methods
    private func resetPets() {
        isFirstLoad = true
        pets = []
    }

    private func handleFetchedPets(_ data: [Pet], resetPagination: Bool) {
        if !isFirstLoad && !data.isEmpty { // If we have started the pagination process and data is not empty
            let debounce = resetPagination ? true : false
            petsSubject.send((data, debounce))
        } else if isFirstLoad && data.isEmpty { // If we haven't start the pagination process and data is empty
            state.send(.empty)
            isFirstLoad = false
        } else if isFirstLoad { // If we haven't start the pagination process and data isn't empty
            isFirstLoad = false
            petsSubject.send((data, false))
        }
    }

    private func handleFetchError(_ error: Error) {
        state.send(.error(.default(error)))
    }
}


