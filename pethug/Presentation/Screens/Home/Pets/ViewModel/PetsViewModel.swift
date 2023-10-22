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
    var collection: String = .getPath(for: .allPets) {
        didSet {
            resetFilterData()
        }
    }
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    private var pets: [Pet] = []
    private var isFetching = false
    private var isFirstLoad = true
    private let fetchAllPetsUC: DefaultFetchAllPetsUC
    private let filterAllPetsUC: DefaultFilterAllPetsUC
    private let fetchPetsUC: DefaultFetchPetsUC
    private let filterPetsUC: DefaultFilterPetsUC
    private let likedPetUC: DefaultLikePetUC
    private let dislikedPetUC: DefaultDisLikePetUC
    private var filterOptions: FilterOptions? = nil
    private var filterMode = false
    
    init(
        fetchAllPetsUC: DefaultFetchAllPetsUC,
        filterAllPetsUC: DefaultFilterAllPetsUC,
        fetchPetsUC: DefaultFetchPetsUC,
        filterPetsUC: DefaultFilterPetsUC,
        likedPetUC: DefaultLikePetUC,
        dislikePetUC: DefaultDisLikePetUC
    ) {
        self.fetchAllPetsUC = fetchAllPetsUC
        self.filterAllPetsUC = filterAllPetsUC
        self.fetchPetsUC = fetchPetsUC
        self.filterPetsUC = filterPetsUC
        self.likedPetUC = likedPetUC
        self.dislikedPetUC = dislikePetUC
        observeState()
        
//        Task {
//            try await uploadNextImage(index:0)
//        }
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
    func fetchPets(collection: String, resetFilterQueries: Bool) {
        if collection == .getPath(for: .allPets) {
            applyFetchAllPets(resetFilterQueries: resetFilterQueries)
        } else {
            applyFetchPets(collection: collection, resetFilterQueries: resetFilterQueries)
        }
        
    }
    
    private func applyFetchAllPets(resetFilterQueries: Bool) {
        print("entra applyfetchallpets: => ")
        if resetFilterQueries {
            resetFilterData()
        }
        guard !isFetching else { return }
        isFetching = true

        Task {
            do {
                guard NetworkMonitor.shared.isConnected == true else {
                    self.state.send(.networkError)
                    isFetching = false
                    return
                }
                let data = try await fetchAllPetsUC.execute(resetFilterQueries: resetFilterQueries)
                handleResult(data)
            } catch {
                handleError(error)
            }
            isFetching = false
        }
    }
    
    private func applyFetchPets(collection: String, resetFilterQueries: Bool) {
        if resetFilterQueries {
            resetFilterData()
        }
        
        guard !isFetching else { return }
        isFetching = true
        
        Task {
            do {
                guard NetworkMonitor.shared.isConnected == true else {
                    self.state.send(.networkError)
                    isFetching = false
                    return
                }
                let data = try await fetchPetsUC.execute(fetchCollection: collection, resetFilterQueries: resetFilterQueries)
                handleResult(data)
            } catch {
                handleError(error)
            }
            
            isFetching = false
        }
    }
    
    //Coordinates the filter process
    func fetchPetsWithFilter(options: FilterOptions? = nil, resetFilterQueries: Bool = false) {
        if self.collection == .getPath(for: .allPets) {
            applyFilterToAllPets(options: options, resetFilterQueries: resetFilterQueries)
        } else {
            applyFilter(options: options, resetFilterQueries: resetFilterQueries)
        }
    }
    
    
    //filterOptions gets set inmediatly after setting the filter options in the app so the next time we
    //call this function we dont need to set again the filter options
    
    private func applyFilterToAllPets(options: FilterOptions?, resetFilterQueries: Bool) {
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
                guard NetworkMonitor.shared.isConnected == true else {
                    self.state.send(.networkError)
                    isFetching = false
                    return
                }
                let data = try await filterAllPetsUC.execute(options: filterOptions, resetFilterQueries: resetFilterQueries)
                handleResult(data)
            } catch {
                handleError(error)
            }
            
            isFetching = false
        }
    }
    
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
                guard NetworkMonitor.shared.isConnected == true else {
                    self.state.send(.networkError)
                    isFetching = false
                    return
                }
                let data = try await filterPetsUC.execute(collection: collection,
                                                          options: filterOptions,
                                                          resetFilterQueries: resetFilterQueries
                                                          )
                handleResult(data)
            } catch {
                handleError(error)
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
    private func handleResult(_ data: [Pet]) {
        if !isFirstLoad && !data.isEmpty {
            petsSubject.send(data)
        } else if isFirstLoad {
            isFirstLoad = false
            petsSubject.send(data)
        }
    }
    
    private func handleError(_ error: Error) {
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
    
    
    func likedPet(pet: Pet, completion: @escaping(Bool) -> Void)  {
        Task{
            do {
                let pet = try addLikeUid(pet: pet)
                try await likedPetUC.execute(data: pet)
                completion(true)
            } catch {
                print("error liking pet: => \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func addLikeUid(pet: Pet) throws -> Pet{
        let uid = AuthService().uid
        
        if pet.likedByUsers.contains(uid) {
            return pet
        }
        
        let updatePet = pet
        updatePet.likedByUsers.append(uid)
        
        if let index = pets.firstIndex(where: { pet in pet.id == updatePet.id }) {
            pets[index] = updatePet
            return updatePet
        }
        
        
        throw PetsError.defaultCustom("Pet index wasn't found")
    }
    
    func removeLikeUid(pet: Pet) throws -> Pet {
        let uid = AuthService().uid
        
        if !pet.likedByUsers.contains(uid) {
            throw PetsError.defaultCustom("User's uid was not found in likedByUsers")
        }
        
        if let index = pet.likedByUsers.firstIndex(of: uid) {
                var updatedPet = pet
                updatedPet.likedByUsers.remove(at: index)
                return updatedPet
            } else {
                throw PetsError.defaultCustom("User's UID not found in likedByUsers")
            }
        
        
    }
    
    func dislikedPet(pet: Pet, completion: @escaping(Bool) -> Void) {
        Task{
            do {
                let pet = try removeLikeUid(pet: pet)
                try await dislikedPetUC.execute(data: pet)
                completion(true)
            } catch {
                print("error liking pet: => \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    
    
    
    
    

//Later i will have to create mock data, ill consider creating it from here or manually 
//    let urlArr = [
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FC9E00B6A-6211-4CD1-ADDD-7FC54A11D4E1?alt=media&token=5dc67013-bc9a-4882-b59c-888b6149b7e4",  "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FCDDE875F-758D-4CB4-8B5E-129CB5BCFB92?alt=media&token=e610245f-2ee9-4260-a4c8-57489fed1b9f",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FC1CEC91F-1E09-4823-8FED-6AFBEF8D4573?alt=media&token=40326176-a97b-4409-a2e3-58e9058b2a6d",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FD1CF2CCC-52AB-4FFF-AFB9-BE757AD75D43?alt=media&token=f6014d8e-4bab-41e3-acfe-bee2a7840723",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F6AC611BB-E6E0-41DE-BC5C-842958A04797?alt=media&token=2d1cda65-76e7-4bd2-a370-a6ac56370a43",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FDCB65454-44DE-41D2-A534-8AFEE2BE4A93?alt=media&token=aac22b89-9b34-401c-be10-5811f0ab44b9",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FBCC5965C-0F2C-440A-A0EA-BB57C68599CB?alt=media&token=21aeccb7-886b-4db7-bd68-ffb9300b8457",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F60412BF1-3257-4C80-91CE-34C15394D82B?alt=media&token=962de63a-ff10-47ef-b956-c7490c02b59b",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FBD6AB0B4-42F7-4B98-ABD3-07DEA961FB03?alt=media&token=a02ec554-c7f2-4bbf-9723-2d2bc2f55cc0",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F585B8035-5B9E-489C-BE22-BA2ADFE8AAE1?alt=media&token=567b274f-ae49-43f5-aa0d-e567da23b3d1",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F55F16EDA-24A8-473C-8AF4-C0E6981FDD1B?alt=media&token=10a9bc9f-13e1-4a80-a91a-c709013fe0ae",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F2B477957-5566-44EB-8B67-C9E9643C7D31?alt=media&token=7beb1c8c-c8cd-4929-a620-1646b621ff5d",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F0760FA7F-AEF0-4138-8DCB-78D975B37C59?alt=media&token=b854ec85-6dd6-4620-84b5-99ff374dde28",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F05091CE3-80D1-4BAB-B0A0-F9A99B26BCD8?alt=media&token=454c6944-2a19-44c6-84d8-55abf38b4840",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F1DC57DE7-4EAC-42D4-9B90-8925F7CD52E1?alt=media&token=b9f104b8-41f9-4615-95de-7fc6668ec75e",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F860E5931-0C81-4D73-94BB-A760A01FB29F?alt=media&token=fca3a937-584d-4a2f-adcc-257e48c64c58",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F603FB9F9-7D26-4321-BA6F-6626B7B639BD?alt=media&token=14b65a33-5d22-42ba-a130-0a0395677a41",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FD1CF2CCC-52AB-4FFF-AFB9-BE757AD75D43?alt=media&token=f6014d8e-4bab-41e3-acfe-bee2a7840723",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F6AC611BB-E6E0-41DE-BC5C-842958A04797?alt=media&token=2d1cda65-76e7-4bd2-a370-a6ac56370a43",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FDCB65454-44DE-41D2-A534-8AFEE2BE4A93?alt=media&token=aac22b89-9b34-401c-be10-5811f0ab44b9",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FBCC5965C-0F2C-440A-A0EA-BB57C68599CB?alt=media&token=21aeccb7-886b-4db7-bd68-ffb9300b8457",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F60412BF1-3257-4C80-91CE-34C15394D82B?alt=media&token=962de63a-ff10-47ef-b956-c7490c02b59b",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2FBD6AB0B4-42F7-4B98-ABD3-07DEA961FB03?alt=media&token=a02ec554-c7f2-4bbf-9723-2d2bc2f55cc0",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F585B8035-5B9E-489C-BE22-BA2ADFE8AAE1?alt=media&token=567b274f-ae49-43f5-aa0d-e567da23b3d1",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F55F16EDA-24A8-473C-8AF4-C0E6981FDD1B?alt=media&token=10a9bc9f-13e1-4a80-a91a-c709013fe0ae",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F2B477957-5566-44EB-8B67-C9E9643C7D31?alt=media&token=7beb1c8c-c8cd-4929-a620-1646b621ff5d",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F0760FA7F-AEF0-4138-8DCB-78D975B37C59?alt=media&token=b854ec85-6dd6-4620-84b5-99ff374dde28",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F585B8035-5B9E-489C-BE22-BA2ADFE8AAE1?alt=media&token=567b274f-ae49-43f5-aa0d-e567da23b3d1",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F55F16EDA-24A8-473C-8AF4-C0E6981FDD1B?alt=media&token=10a9bc9f-13e1-4a80-a91a-c709013fe0ae",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F2B477957-5566-44EB-8B67-C9E9643C7D31?alt=media&token=7beb1c8c-c8cd-4929-a620-1646b621ff5d",
//        "https://firebasestorage.googleapis.com:443/v0/b/pethug-8ad19.appspot.com/o/bird_profile_images%2F0760FA7F-AEF0-4138-8DCB-78D975B37C59?alt=media&token=b854ec85-6dd6-4620-84b5-99ff374dde28"
//    ]
//
//    let uid = AuthService().uid
//
//    func uploadNextImage(index: Int) async throws {
//
//        print("crea pet: => \(index)")
//        guard index < 30 else { print(": => FINISHED REGISTERING DOGS YEAH"); return }
//
//        let url = urlArr[index]
//
//        let pet: Pet = .init(
//            id: UUID().uuidString,
//            name: "SLR - \(index)",
//            gender: .female,
//            breed: index % 2 == 0 ? "Dachshund" : "Minitauro",
//            imagesUrls: [url],
//            type: .bird,
//            age: 3,
//            activityLevel: 6,
//            socialLevel: 7,
//            affectionLevel: 8,
//            address: index % 2 == 0 ? .MexicoCity : .Jalisco,
//            info: "Test dog for pagination firebase",
//            isLiked: index % 2 == 0 ?  true : false,
//            timestamp: Timestamp(date: Date()),
//            owneruid: uid,
//            likedByUsers: []
//        )
//
//        let res = try await createPet(data: pet)
//
//        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
//
//        try await uploadNextImage(index: index + 1)
//    }
//
//    private  var db = Firestore.firestore()
//
//    func createPet(collection path: String = "birds", data: Pet) async throws -> Bool {
//        let uid = AuthService().uid
//        let petFirebaseEntinty = data.toFirebaseEntity()
//        let dataModel = petFirebaseEntinty.toObjectLiteral()
//        try await db.collection(path)
//            .document(data.id)
//            .setData(dataModel)
//
//        try await db.collection("users")
//            .document(uid)
//            .collection("pets")
//            .document(data.id)
//            .setData(dataModel)
//        return true
//
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


