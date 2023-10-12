//
//  NewPetViewModel.swift
//  pethug
//
//  Created by Raul Pena on 01/10/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import Combine

class NewPetViewModel {
    //MARK: - Private properties
    private let imageService: ImageServiceProtocol
    private let createPetUseCase: DefaultCreatePetUC
    private let updatePetUseCase: DefaultUpdatePetUC
    private let deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    //MARK: - Internal Properties
    private var pet: Pet?
    init(imageService: ImageServiceProtocol, createPetUseCase: DefaultCreatePetUC, updatePetUseCase: DefaultUpdatePetUC, deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC) {
        self.imageService = imageService
        self.createPetUseCase = createPetUseCase
        self.updatePetUseCase = updatePetUseCase
        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
        observeValidation()
        
        //        mockDecodePetModel()
    }
    
    init(imageService: ImageServiceProtocol, createPetUseCase: DefaultCreatePetUC, updatePetUseCase: DefaultUpdatePetUC, deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC, pet: Pet? = nil) {
        print("recibio pet en newpet view model 444 : => \(String(describing: pet?.imagesUrls))")
        self.imageService     = imageService
        self.createPetUseCase = createPetUseCase
        self.updatePetUseCase = updatePetUseCase
        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
        self.pet = pet
        self.isEdit = pet != nil
        observeValidation()
//        Task {
//            try await uploadNextImage(index: 0)
//        }
        //        let imagesArr = getImages(stringUrlArray: pet?.imagesUrls ?? [])
        self.imagesToEditState = pet?.imagesUrls ?? []
        self.nameState      = pet?.name
        self.galleryState   = []
        self.typeState      = pet?.type
        self.breedsState    = pet?.breed
        self.genderState    = pet?.gender
        self.sizeState      = pet?.size
        self.ageState       = pet?.age
        self.activityState  = pet?.activityLevel
        self.socialState    = pet?.socialLevel
        self.affectionState = pet?.affectionLevel
        self.addressState   = pet?.address
        self.infoState      = pet?.info
        
        //        mockDecodePetModel()
    }
    
//    func mockDecodePetModel() {
//        print("corre mock pet model decode 789: => ")
//        //        let petModel: PetModel = PetModel(id: "3323-ews3", name: "Joanna Camacho", age: 22, gender: "female", size: "small", breed: "Dachshund", imagesUrls: ["firebase.com/ImageExampleMyCousin"], type: "dog", address: "Sinaloa", isLiked: false)
//
//        let petModelData: [String: Any] = [
//            "id": "3323-ews3",
//            "name": "Joanna Camacho",
//            "age": 22,
//            "gender": "female",
//            "size": "small",
//            "breed": "Dachshund",
//            "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
//            "type": "dog",
//            "address": "Sinaloa",
//            "isLiked": false
//        ]
//
//        if let jsonData = try? JSONSerialization.data(withJSONObject: petModelData, options: []) {
//            let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
//
//            print("data firebase niga PET IN CUSTOM DECODER: => \(pet?.address)")
//        }
//
//    }
    
    //MARK: - Form Validation
    private var cancellables = Set<AnyCancellable>()
    
    @Published var nameState:     String? = nil
    @Published var galleryState:  [UIImage] = []
    @Published var typeState:     Pet.PetType? = nil
    @Published var breedsState:   String? = nil
    @Published var genderState:   Pet.Gender? = nil
    @Published var sizeState:     Pet.Size? = nil
    @Published var ageState:      Int? = nil
    @Published var activityState: Int? = nil
    @Published var socialState:   Int? = nil
    @Published var affectionState: Int? = nil
    @Published var addressState:  Pet.State? = nil
    @Published var infoState:     String? = nil
    
    var imagesToEditState: [String] = []
    var isEdit = false
    var isValidSubject = CurrentValueSubject<Bool, Never>(false)
    var stateSubject = PassthroughSubject<LoadingState, Never>()
    
    func observeValidation() {
        formValidationState.sink(receiveValue: { state in
            switch state {
            case .valid:
                self.isValidSubject.send(true)
                print("is valid 666")
            case .invalid:
                print("is inValid 666")
                self.isValidSubject.send(false)
            }
        }).store(in: &cancellables)
    }
    
    var formValidationState: AnyPublisher<State, Never> {
        return Publishers.CombineLatest4(
            Publishers.CombineLatest3($nameState, $galleryState, $typeState),
            Publishers.CombineLatest3($breedsState, $genderState, $sizeState),
            Publishers.CombineLatest4($ageState, $activityState, $socialState, $affectionState),
            Publishers.CombineLatest($addressState, $infoState)
        )
        .map { [weak self] nameGalleryType, breedGenderSize, petStats, addressInfo in
            guard let self = self else { return .invalid }
            let (name, gallery, type) = nameGalleryType
            let (breed, gender, size) = breedGenderSize
            let (age, activity, social, affection) = petStats
            let (address, info) =  addressInfo
            
            return self.validateForm(
                name: name,
                gallery: gallery,
                type: type,
                breed: breed,
                gender: gender,
                size: size,
                age: age,
                activity: activity,
                social: social,
                affection: affection,
                address: address,
                info: info
            )
            
        }
        .eraseToAnyPublisher()
    }
    
    func validateForm(
        name: String?,
        gallery: [UIImage],
        type: Pet.PetType?,
        breed: String?,
        gender: Pet.Gender?,
        size: Pet.Size?,
        age: Int?,
        activity: Int?,
        social: Int?,
        affection: Int?,
        address: Pet.State?,
        info: String?
    ) -> State{
        //gender and size are optional for the user
        //        print("name level en viewmodel: => 666 \(name)")
        //        print("gallery level en viewmodel: => 221 \(gallery)")
        //        print("gallery level is empty? en viewmodel: => 221 \(gallery.isEmpty)")
        //          print("gallery count en viewmodel: => 221 \(gallery.count)")
        //        print("type level en viewmodel: => 666 \(type)")
        //        print("breed level en viewmodel: => 666 \(breed)")
        //        print("age level en viewmodel: => 666 \(age)")
        //        print("activity level en viewmodel: => 221 \(activity)")
        //        print("social level en viewmodel: => 666 \(social)")
        //        print("affection level en viewmodel: => 666 \(affection)")
        //        print("address level en viewmodel: => 666 \(address)")
        //        print("info level en viewmodel: => 666 \(info)")
        //        print("gender en viewmodel: => 666 \(gender)")
        
        //       gender and size props are optional
        if name == nil      ||
            gallery.isEmpty  ||
            type == nil      ||
            breed == nil     ||
            age == nil       ||
            activity == nil  ||
            social == nil    ||
            affection == nil ||
            address == nil   ||
            info == nil {
            return .invalid
        }
        
        return .valid
    }
    
    //MARK: - Upload new pet
    func createPet() async {
        stateSubject.send(.loading)
        
        do {
            var imagesUrls = [String]()
            
            try await uploadNextImage(index: 0, imagesUrls: &imagesUrls)
            
            let pet = Pet(
                id: UUID().uuidString,
                name: nameState!,
                gender: genderState,
                size: sizeState,
                breed: breedsState!,
                imagesUrls: imagesUrls,
                type: typeState!,
                age: ageState!,
                activityLevel: activityState!,
                socialLevel: socialState!,
                affectionLevel: affectionState!,
                address: addressState!,
                info: infoState!,
                isLiked: false,
                timestamp: Timestamp(date: Date())
            )
            
            
            let _ = try await executeCreatePet(pet: pet)
            
            stateSubject.send(.success)
            
        } catch {
            stateSubject.send(.error(.default(error)))
        }
        
    }
    
    private func executeCreatePet(pet: Pet) async throws -> Bool{
        let path = pet.type.getPath
        return try await createPetUseCase.execute(collection: path, data: pet)
    }
    
    func updatePet() async {
        
        stateSubject.send(.loading)
        
        do {
            var imagesUrls = [String]()
            
            try await uploadNextImage(index: 0, imagesUrls: &imagesUrls)
            guard let currentPet = pet else { return }
            let pet = Pet(
                id: currentPet.id,
                name: nameState!,
                gender: genderState,
                size: sizeState,
                breed: breedsState!,
                imagesUrls: imagesUrls,
                type: typeState!,
                age: ageState!,
                activityLevel: activityState!,
                socialLevel: socialState!,
                affectionLevel: affectionState!,
                address: addressState!,
                info: infoState!,
                isLiked: currentPet.isLiked,
                timestamp: currentPet.timestamp
            )
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            let _ = try await executeUpdatePet(pet: pet)
            dispatchGroup.leave()
            
            if currentPet.type != pet.type {
                dispatchGroup.enter()
                try await deleteFromRepeated(collection: currentPet.type.getPath, id: pet.id)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            imageService.deleteImages(imagesUrl: currentPet.imagesUrls)
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: .main){ [weak self] in
                self?.stateSubject.send(.success)
            }
            
        } catch {
            stateSubject.send(.error(.default(error)))
        }
        
    }
    
    private func executeUpdatePet(pet: Pet) async throws -> Bool{
        let path = pet.type.getPath
        
        return try await updatePetUseCase.execute(collection: path, data: pet)
    }
    
    //Recursively Upload images in sequence to respect the order in which the user selected the images
    func uploadNextImage(index: Int, imagesUrls: inout [String]) async throws {
        guard let typeState = typeState else { return }
        let path = typeState.storagePath
        
        
        guard index < galleryState.count else { return }
        
        let image = galleryState[index]
        
        let imageUrl = try await imageService.uploadImage(image: image, path: path)
        if let  imageUrl = imageUrl {
            imagesUrls.append(imageUrl)
        }
        try await uploadNextImage(index: index + 1, imagesUrls: &imagesUrls)
        
        
    }
    //Delete pet from old collection when user changes its type, eg: change from pet -> to bird
    func deleteFromRepeated(collection path: String, id: String) async throws {
        _ = try await deletePetFromRepeatedCollectionUC.execute(collection: path, docId: id)
    }
    
}
    
    
    
    
    
    
    



