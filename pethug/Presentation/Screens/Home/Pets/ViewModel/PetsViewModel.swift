//
//  PetsViewModel.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
import Combine
import FirebaseFirestore
import Firebase

protocol PetsNavigatable: AnyObject {
    func tapped(pet: Pet)
    func tappedFilter()
}

class PetsViewModel {
    //MARK: - Internal Properties
    weak var navigation: PetsNavigatable?
    var state = PassthroughSubject<State,Never>()
    var collection: String = .getPath(for: .allPets) {
        didSet {
            resetData() // When collection changes reset data
        }
    }
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private(set) var pets: [Pet] = []
    private(set) var isFetching = false
    private(set) var isFirstLoad = true // Flag indicates if the pagination process has started
    private let fetchAllPetsUC: DefaultFetchAllPetsUC
    private let filterAllPetsUC: DefaultFilterAllPetsUC
    private let fetchPetsUC: DefaultFetchPetsUC
    private let filterPetsUC: DefaultFilterPetsUC
    private let likedPetUC: DefaultLikePetUC
    private let dislikedPetUC: DefaultDisLikePetUC
    private let authService: AuthServiceProtocol
    private(set) var filterOptions: FilterOptions? = nil
    private(set) var filterMode = false // Flag indicating if we are requesting a fetch with fitler options
    
    init(
        fetchAllPetsUC: DefaultFetchAllPetsUC,
        filterAllPetsUC: DefaultFilterAllPetsUC,
        fetchPetsUC: DefaultFetchPetsUC,
        filterPetsUC: DefaultFilterPetsUC,
        likedPetUC: DefaultLikePetUC,
        dislikePetUC: DefaultDisLikePetUC,
        authService: AuthServiceProtocol
    ) {
        self.fetchAllPetsUC = fetchAllPetsUC
        self.filterAllPetsUC = filterAllPetsUC
        self.fetchPetsUC = fetchPetsUC
        self.filterPetsUC = filterPetsUC
        self.likedPetUC = likedPetUC
        self.dislikedPetUC = dislikePetUC
        self.authService = authService
        observeState()
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
        } receiveValue: { [weak self] pets in
            guard let self = self else { return }
            self.pets.append(contentsOf: pets)
            self.state.send(.loaded(self.pets))
        }.store(in: &subscriptions)

    }
    
    //MARK: - Internal Methods
    // Coordinates fetch pets
    func fetchPets(collection: String, resetFilterQueries: Bool) async {
        filterMode = false
        
        guard !isFetching else { return }
        isFetching = true
        
        // Reset state variables when performing the first fetch
        if resetFilterQueries {
            resetData()
        }
        
        if collection == .getPath(for: .allPets) {
            await applyFetchAllPets(resetFilterQueries: resetFilterQueries) // Fetch all pets collections
        } else {
            await applyFetchPets(collection: collection, resetFilterQueries: resetFilterQueries) // Fetch specific pet collection
        }
    }
    
    // Coordinates fetch pets with filter options
    func fetchPetsWithFilter(options: FilterOptions? = nil, resetFilterQueries: Bool = false) async {
        filterMode = true
        
        guard !isFetching else { return }
        isFetching = true
        
        if isFirstLoad {
            //Send loading state
            state.send(.loading)
        }
        
        // Reset state variables when performing the first fetch
        if resetFilterQueries {
            resetData()
        }
        // If new filter options are provided, update the filterOptions variable
        if options != nil {
            filterOptions = options
        }
        
        guard let filterOptions = filterOptions else { return }
        
        if self.collection == .getPath(for: .allPets) {
            await applyFilterToAllPets(options: filterOptions, resetFilterQueries: resetFilterQueries) // Fetch all pets collections with filter options
        } else {
            await applyFilter(options: filterOptions, resetFilterQueries: resetFilterQueries) // Fetch specific pet collection with filter options
        }
    }
    
    
    func likedPet(pet: Pet, completion: @escaping(Bool) -> Void) async {
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let pet = try addLike(pet: pet) // Update pets array
            try await likedPetUC.execute(data: pet) // Update in db
            completion(true)
        } catch {
            print("error liking pet: => \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func dislikedPet(pet: Pet, completion: @escaping(Bool) -> Void) async {
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let pet = try removeLikeUid(pet: pet)
            try await dislikedPetUC.execute(data: pet)
            completion(true)
        } catch {
            print("error liking pet: => \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func isFilterMode() -> Bool {
        return filterMode
    }
    
    //MARK: - Private methods
    private func applyFetchAllPets(resetFilterQueries: Bool) async {
        defer {
            isFetching = false
        }
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let data = try await fetchAllPetsUC.execute(resetFilterQueries: resetFilterQueries) // Fetch pets
            handleResult(data)
        } catch {
            handleError(error)
        }
        
    }
    
    private func applyFetchPets(collection: String, resetFilterQueries: Bool) async {
        defer {
            isFetching = false
        }
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let data = try await fetchPetsUC.execute(fetchCollection: collection, resetFilterQueries: resetFilterQueries) // Fetch pets
            handleResult(data)
        } catch {
            handleError(error)
        }
        
    }
    
    //MARK: - Filter pets
    // The viewModel instance is shared, so we update the filterOptions when new options are provided.
    private func applyFilterToAllPets(options: FilterOptions, resetFilterQueries: Bool) async {
        defer {
            isFetching = false
        }
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let data = try await filterAllPetsUC.execute(options: options, resetFilterQueries: resetFilterQueries) // Fetch pets
            handleResult(data)
        } catch {
            handleError(error)
        }
    }
    
    // The viewModel instance is shared, so we update the filterOptions when new options are provided.
    private func applyFilter(options: FilterOptions, resetFilterQueries: Bool) async {
        defer {
            isFetching = false
        }
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                self.state.send(.networkError)
                return
            }
            let data = try await filterPetsUC.execute(collection: collection,
                                                      options: options,
                                                      resetFilterQueries: resetFilterQueries) // Fetch pets
            handleResult(data)
        } catch {
            handleError(error)
        }
    }
    
   
    //Resets the filter data and marks it as the first load when new filter options are applied.
    private func resetData() {
        isFirstLoad = true //Indicates that pagination process hasn't started yet
        pets = []
    }
    
    
    private func handleResult(_ data: [Pet]) {
        defer {
            isFirstLoad = false
        }
        
        if !isFirstLoad && !data.isEmpty { // If we have started the pagination process and data is not empty
            petsSubject.send(data)
        } else if isFirstLoad && data.isEmpty { // If we haven't started the pagination process and data is empty
            state.send(.empty)
        } else if isFirstLoad { // If we haven't started the pagination process and data isn't empty
            isFirstLoad = false
            petsSubject.send(data)
        }
    }
    
    private func handleError(_ error: Error) {
        state.send(.loaded([]))
        state.send(.error(.default(error)))
    }
    
  private func addLike(pet: Pet) throws -> Pet{
        let uid = authService.uid
        
        if pet.likedByUsers.contains(uid) {
            return pet
        }
        
        let updatePet = pet
        updatePet.likedByUsers.append(uid)
        updatePet.likesTimestamps.append(.init(uid: uid, timestamp: Timestamp(date: Date())))
        
        if let index = pets.firstIndex(where: { pet in pet.id == updatePet.id }) {
            pets[index] = updatePet
            return updatePet
        }
        
        throw PetsError.defaultCustom("Pet index wasn't found")
    }
    

    
    private func removeLikeUid(pet: Pet) throws -> Pet {
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
    
}
