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
                petsSubject.send(data)
                
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



