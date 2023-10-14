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

final class PetsViewModel {
    //MARK: - Internal Properties
    weak var navigation: PetsNavigatable?
    var state = PassthroughSubject<State,Never>()
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private var pets: [Pet] = []
    
    private var isFetching = false
    private var isFirstLoad = true
    private let fetchPetsUC: DefaultFetchPetsUC
    private let filterPetsUC: DefaultFilterPetsUC
    private var filterOptions: FilterOptions? = nil
    private var filterMode = false
    
    init(fetchPetsUC: DefaultFetchPetsUC, filterPetsUC: DefaultFilterPetsUC) {
        self.fetchPetsUC = fetchPetsUC
        self.filterPetsUC = filterPetsUC
        observeState()
        fetchPets(collection: .getPath(for: .birds))
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
    func fetchPets(collection: String) {
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                let data = try await fetchPetsUC.execute(fetchCollection: collection)
                if !isFirstLoad && !data.isEmpty {
                    petsSubject.send(data)
                } else if isFirstLoad {
                    petsSubject.send(data)
                    isFirstLoad = false
                }
                
            } catch {
                state.send(.error(.default(error)))
            }
            
            isFetching = false
        }
    }
    
//    func fetchPetsWithFilter(options: FilterOptions? = nil, resetFilterQueries: Bool = false) {
//        filterMode = true
//        if options != nil {
//            filterOptions = options
//        }
//
//        if resetFilterQueries {
//            print("entra reset firstload: => \(resetFilterQueries)")
//            isFirstLoad = true
//            pets = []
//        }
//
//        if isFirstLoad {
//            state.send(.loading)
//        }
//
//        print("filter options en fecthpets with filter 931: => \(filterOptions)")
//        guard let filterOptions = filterOptions else { return }
//        guard !isFetching else { return }
//        isFetching = true
//
//        Task {
//            do {
//
//                let data = try await filterPetsUC.execute(options: filterOptions, resetFilterQueries: resetFilterQueries)
//                if !isFirstLoad && !data.isEmpty {
//                    print("no es firstload envia la dadta: => \(data)")
//                    petsSubject.send(data)
//
//                } else if isFirstLoad {
//                    isFirstLoad = false
//                    petsSubject.send(data)
//                }
//
//            } catch {
//                state.send(.loaded([]))
//                state.send(.error(.default(error)))
//            }
//
//            isFetching = false
//        }
//    }
    
    //Coordinates the filter process
    func fetchPetsWithFilter(options: FilterOptions? = nil, resetFilterQueries: Bool = false) {
        applyFilter(options: options, resetFilterQueries: resetFilterQueries)
    }
    
    //Main logic for applying the filter
    private func applyFilter(options: FilterOptions?, resetFilterQueries: Bool) {
        filterMode = true
        if options != nil {
            filterOptions = options
        }
        
        if resetFilterQueries {
            resetFilterData()
        }
        
        if isFirstLoad {
            state.send(.loading)
        }
        
        guard let filterOptions = filterOptions else { return }
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                let data = try await filterPetsUC.execute(options: filterOptions, resetFilterQueries: resetFilterQueries)
                handleFilterResult(data)
            } catch {
                handleFilterError(error)
            }
            
            isFetching = false
        }
    }
    //Resets the filter data and marks it as the first load when new filter options are applied.
    private func resetFilterData() {
        isFirstLoad = true //Indicates that a new search has begun with new filter options
        pets = []
    }
    
    //If not the first load and the results are not empty, send the data.
    //Otherwise, if it's the first load with new filter options, mark isFirstLoad as false and send data whether is empty or not.
    private func handleFilterResult(_ data: [Pet]) {
        if !isFirstLoad && !data.isEmpty {
            petsSubject.send(data)
        } else if isFirstLoad {
            isFirstLoad = false
            petsSubject.send(data)
        }
    }
    
    private func handleFilterError(_ error: Error) {
        state.send(.loaded([]))
        state.send(.error(.default(error)))
    }
    
    func isFilterMode() -> Bool {
        return filterMode
    }
    
    
//    private func createMockPet() {
//        let pet: Pet = .init(id: "552-omega", name: "Doli", age: 4, gender: .female, size: .large, breed: "labrador", imagesUrls: [], type: .dog, address: .NuevoLeon, isLiked: false)
//        let db = Firestore.firestore()
//        Task {
//            do {
//                try db.collection(.getPath(for: .dogs)).document(pet.id).setData(from: pet)
//            } catch {
//                
//            }
//        }
//    }
    
    
    
//    private func createMockPet() {
//        let pet: Pet = .init(id: "552-omega", name: "Doli", age: 4, gender: "f", size: "xl", breed: "labrador", imageUrl: "km", type: .dog(.goldenRetriever))
//        let data = pet.toObjectLiteral()
//        let db = Firestore.firestore()
//        Task {
//            do {
//
//                print("creating mock pet: => \(pet)")
//                let encoder = JSONEncoder()
//                      let data2 = try encoder.encode(pet)
//
//                if let petDictionary = try JSONSerialization.jsonObject(with: data2, options: []) as? [String: Any] {
//                    print(": mock pet dictionary => \(petDictionary)")
////                    try await db.collection(.getPath(for: .dogs)).document(pet.id).setData(petDictionary)
//                    ///Instead of enconding manually we use setData(from: [our data structure])
//                    try db.collection(.getPath(for: .dogs)).document(pet.id).setData(from: pet)
//                    print("data en fetch pets(): => \(data)")
//                }
//
//            } catch {
//
//            }
//        }
//    }
    
//    private func fetchPet() {
//        let db = Firestore.firestore()
//
//        db.collection(.getPath(for: .dogs)).document("332-alpha").getDocument { (document, error) in
//            if let document = document, document.exists {
//                do {
//                    if let data = document.data() {
//                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                        let decoder = JSONDecoder()
//                        let pet = try decoder.decode(Pet.self, from: jsonData)
//                        print("Fetched pet: => \(pet)")
//                    }
//                } catch {
//                    print("Error decoding pet: \(error)")
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }

}


//Request manager swft mrvl
//protocol DataParser {
//    func parse<T: Decodable>(data: Data) throws -> T
//}
//
//class DefaultDataParser: DataParser {
//    private var jsonDecoder: JSONDecoder
//    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
//        self.jsonDecoder = jsonDecoder
//    }
//    func parse<T: Decodable>(data: Data) throws -> T {
//        return try jsonDecoder.decode(T.self, from: data)
//    }
//}


