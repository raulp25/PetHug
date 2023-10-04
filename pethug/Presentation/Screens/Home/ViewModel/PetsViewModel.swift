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
        observeState()
        fetchPets(collection: .getPath(for: .dogs))
        ///Mock pet, do not uncomment
//        createMockPet()
        
//        fetchPet()
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


